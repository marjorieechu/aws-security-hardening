# Download Prowler binary
git clone https://github.com/prowler-cloud/prowler
cd prowler
./install.sh
cp prowler ../lambda_code/

# Prepare ZIP
cd ../lambda_code
cp ../index.py .
zip prowler_lambda.zip index.py prowler
