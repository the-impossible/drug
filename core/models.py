from django.db import models

# Create your models here.
import uuid
from django.db import models

from accounts.models import CustomUser, Patient

# Create your models here.
class Drug(models.Model):
    drug_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    name = models.CharField(max_length=50)
    gram = models.FloatField()
    expiry_date = models.DateField()
    price = models.FloatField()

    def __str__(self):
        return f"{self.name} - {self.price}"
    
class Prescription(models.Model):
    pres_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name="patient")
    doctor = models.ForeignKey(CustomUser, on_delete=models.SET_DEFAULT, default=CustomUser.objects.get(username='admin').user_id, related_name="doctor")
    date = models.DateTimeField(auto_now_add=True)
    diagnosis = models.CharField(max_length=200)
    payment_status = models.BooleanField(default=False)
    total = models.FloatField()
    qr_image = models.ImageField(upload_to='qr_code/', default="default.jpg")

    def __str__(self):
        return f"Patient: {self.patient}, Total: {self.total}, Payment Status: {self.payment_status}"
    # prescription.drugs_prescribed.all()

class DrugPrescribed(models.Model):
    drugpres_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    drug = models.ForeignKey(Drug, on_delete=models.CASCADE)
    dosage = models.CharField(max_length=50)
    quantity = models.PositiveIntegerField()
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name="drugs_prescribed", default=None)
    total = models.FloatField(default=0.0)
    def __str__(self):
        return f"{self.drug.name}, dosage: {self.dosage}"
    

    

    