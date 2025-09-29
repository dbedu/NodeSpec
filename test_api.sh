#!/bin/bash

# Test script to verify API endpoint connectivity
API_URL="https://api.nodespec.com"

echo "Testing NodeSpec API endpoints..."

# Test 1: Health check
echo "1. Testing health check..."
health_response=$(curl -s "$API_URL/health")
echo "Health response: $health_response"

# Test 2: Check if submit endpoint exists
echo -e "\n2. Testing submit endpoint availability..."
submit_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/submit")
echo "Submit endpoint HTTP status: $submit_response"

# Test 3: Check if submit endpoint exists with /api prefix
echo -e "\n3. Testing /api/submit endpoint availability..."
api_submit_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/api/submit")
echo "/api/submit endpoint HTTP status: $api_submit_response"

# Test 4: Try a minimal valid request to see actual error
echo -e "\n4. Testing with minimal data to see actual error response..."
test_response=$(curl -s -X POST "$API_URL/submit" \
  -F "test_id=test_123" \
  -F "test_time=$(date -Iseconds)" \
  -F "script_version=1.0.0")
echo "Test response: $test_response"

echo -e "\nTest complete!"