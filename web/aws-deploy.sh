aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 425766172722.dkr.ecr.us-east-1.amazonaws.com
docker build -t 425766172722.dkr.ecr.us-east-1.amazonaws.com/jitsi-meet-web .
docker tag 425766172722.dkr.ecr.us-east-1.amazonaws.com/jitsi-meet-web:latest 425766172722.dkr.ecr.us-east-1.amazonaws.com/jitsi-meet-web:latest
docker push 425766172722.dkr.ecr.us-east-1.amazonaws.com/jitsi-meet-web:latest