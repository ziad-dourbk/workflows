#!/bin/bash

# Create zip for function1
cd function1
zip -r ../function1-source.zip ./*

# Create zip for function2
cd ../function2
zip -r ../function2-source.zip ./*

# Move zip files to terraform directory
mv ../function1-source.zip ../workflows/scripts/terraform/
mv ../function2-source.zip ../workflows/scripts/terraform/

echo "Build complete! Zip files moved to terraform directory."
