from rest_framework import serializers
from accounts.serializers import UserDetailsSerializer, PatientSerializer
from .models import Drug, DrugPrescribed, Prescription

class DrugSerializer(serializers.ModelSerializer):
    class Meta:
        model = Drug
        fields = "__all__"

class DrugPrescribedSerializer(serializers.ModelSerializer):
    # drug = DrugSerializer()
    class Meta:
        model = DrugPrescribed
        fields = "__all__"

class FullDrugPrescribedSerializer(serializers.ModelSerializer):
    drug = DrugSerializer()
    class Meta:
        model = DrugPrescribed
        fields = "__all__"

class PrescriptionSerializer(serializers.ModelSerializer):
    drug_prescribed = DrugPrescribedSerializer(many=True, required=False)
    total = serializers.CharField(required=False)
    class Meta:
        model = Prescription
        exclude = ["doctor"]

class FullPrescriptionSerializer(serializers.ModelSerializer):
    # drug_prescribed = DrugPrescribedSerializer(many=True)
    patient = PatientSerializer()
    class Meta:
        model = Prescription
        fields = "__all__"

class PaymentStatusUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = ['payment_status']
    
