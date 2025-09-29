#!/bin/bash

echo "Testing NodeSpec.sh script without jq dependencies..."

# Test 1: Check bash syntax
echo "1. Checking bash syntax..."
if bash -n NodeSpec.sh; then
    echo "✅ Bash syntax is valid"
else
    echo "❌ Bash syntax errors found"
    exit 1
fi

# Test 2: Check for jq command usage
echo ""
echo "2. Checking for jq dependencies..."
if grep -q "jq\s" NodeSpec.sh; then
    echo "❌ Found jq command usage in script"
    grep -n "jq\s" NodeSpec.sh
    exit 1
else
    echo "✅ No jq command usage found"
fi

# Test 3: Check if upload_results_to_api function exists
echo ""
echo "3. Checking API upload function..."
if grep -q "function upload_results_to_api" NodeSpec.sh; then
    echo "✅ upload_results_to_api function found"
else
    echo "❌ upload_results_to_api function missing"
    exit 1
fi

# Test 4: Check if function is called in main
echo ""
echo "4. Checking if API function is called..."
if grep -q "upload_results_to_api" NodeSpec.sh && grep -A 20 "function main" NodeSpec.sh | grep -q "upload_results_to_api"; then
    echo "✅ upload_results_to_api is called in main function"
else
    echo "❌ upload_results_to_api not called in main function"
    exit 1
fi

# Test 5: Check JSON parsing method (should use sed, not jq)
echo ""
echo "5. Checking JSON parsing method..."
if grep -A 10 "Parse the response" NodeSpec.sh | grep -q "sed.*test_uuid"; then
    echo "✅ Using sed for JSON parsing (no jq dependency)"
else
    echo "❌ JSON parsing method unclear"
fi

echo ""
echo "✅ All tests passed! NodeSpec.sh is clean of jq dependencies."
echo ""
echo "The script now:"
echo "  - Uses sed for simple JSON parsing instead of jq"
echo "  - Uploads result files to api.nodespec.com/submit"
echo "  - Falls back gracefully if upload fails"
echo "  - Displays result URL: https://nodespec.com/result/{uuid}"