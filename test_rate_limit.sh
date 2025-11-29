#!/bin/bash

# Test script for rate limiting
# This script makes multiple requests to test the rate limiting

API_KEY="sk_2265f930046aab956a6bbed8ac9719cec6726c1914c19e4bcba7c05cd609a5ce" # Free plan (100 req/hour)
BASE_URL="http://localhost:9292"

echo "Testing rate limiting with Free plan (100 req/hour)..."
echo "Making 5 requests to check headers..."
echo ""

for i in {1..5}; do
  echo "Request $i:"
  curl -s -X GET "$BASE_URL/api/v1/cars" \
    -H "Authorization: Bearer $API_KEY" \
    -i | grep -E "^(HTTP|x-ratelimit)"
  echo ""
  sleep 0.5
done

echo "Test completed!"
echo ""
echo "To test rate limit blocking, you would need to make 100+ requests."
echo "The X-RateLimit-Remaining header should decrease with each request."
