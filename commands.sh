#!/bin/sh

echo " -------------"
echo "| GCLOUD INFO |"
echo " -------------"
gcloud info

echo " ------------------------"
echo "| KUBECTL CLIENT VERSION |"
echo " ------------------------"
kubectl version --client
echo ""

echo " ---------------------"
echo "| HELM CLIENT VERSION |"
echo " ---------------------"
helm version --client
echo ""

echo " ====================== "
echo " "
echo "To run a custom script, just mount it '--volume /your/script.sh:/data/commands.sh:ro'"
