# ==================================================================
# API INTEGRATION FUNCTIONS - ADD THESE TO NodeSpec.sh
# ==================================================================

function upload_results_to_api(){
    _green_bold "\n========== Uploading Results to API =========="

    local api_endpoint="https://api.nodespec.com/submit"
    local test_time=$(date +"%Y-%m-%d %H:%M:%S")
    local test_id="${current_time}_$(uname -n | cut -d'.' -f1)"

    _blue "Collecting result files..."
    local files=()
    local file_list=(
        "$header_info_filename"
        "$basic_info_filename"
        "$yabs_json_filename"
        "$ip_quality_filename"
        "$ip_quality_json_filename"
        "$net_quality_filename"
        "$net_quality_json_filename"
        "$backroute_trace_filename"
        "$backroute_trace_json_filename"
        "$port_filename"
    )

    for filename in "${file_list[@]}"; do
        local file_path="$result_directory/$filename"
        if [[ -f "$file_path" ]]; then
            files+=("$file_path")
        fi
    done

    if [[ ${#files[@]} -eq 0 ]]; then
        _red "Error: No result files found to upload"
        return 1
    fi

    _blue "Found ${#files[@]} result files"

    # Prepare multipart form data
    local curl_args=()
    curl_args+=("-X" "POST")
    curl_args+=("-H" "Content-Type: multipart/form-data")
    curl_args+=("-F" "test_id=$test_id")
    curl_args+=("-F" "test_time=$test_time")
    curl_args+=("-F" "script_version=$SCRIPT_VERSION")

    # Add each file to the form data
    for file in "${files[@]}"; do
        local filename=$(basename "$file")
        curl_args+=("-F" "files[]=@$file;filename=$filename")
    done

    _blue "Uploading results to api.nodespec.com..."

    # Perform the upload
    local response=$(curl -s --max-time 30 "${curl_args[@]}" "$api_endpoint")
    local curl_exit_code=$?

    if [[ $curl_exit_code -ne 0 ]]; then
        _red "Error: Failed to upload results (curl exit code: $curl_exit_code)"
        _yellow "Falling back to local report generation..."
        generate_final_report_legacy
        return 1
    fi

    # Parse the response to get the result URL
    local result_url=""
    if command -v jq &> /dev/null && echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        result_url=$(echo "$response" | jq -r '.result_url // empty')
        local test_uuid=$(echo "$response" | jq -r '.test_uuid // empty')

        if [[ -n "$result_url" && -n "$test_uuid" ]]; then
            _green_bold "\n================================================="
            _green_bold "         UPLOAD SUCCESSFUL!"
            _green_bold "================================================="
            _blue "Your test results have been uploaded successfully!"
            _yellow "View your detailed test report at:"
            _green_bold "https://nodespec.com/result/$test_uuid"
            _green_bold "================================================="
            return 0
        fi
    fi

    # If we get here, the API response was invalid
    _red "Error: Invalid response from API"
    _yellow "Response: $response"
    _yellow "Falling back to local report generation..."
    generate_final_report_legacy
    return 1
}

# ==================================================================
# INSTRUCTIONS FOR INTEGRATION:
# ==================================================================
# 1. Add the above function to your NodeSpec.sh file before the existing generate_final_report function
# 2. Rename your existing generate_final_report function to generate_final_report_legacy
# 3. Replace the call to generate_final_report in main() with upload_results_to_api
# 4. Make sure $result_directory variable is set correctly (should be $work_dir/BenchOs/result)
#
# Example integration in main() function:
#     upload_results_to_api
#     _green_bold 'Clean Up after Installation'
#     post_cleanup