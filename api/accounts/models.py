import uuid
from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here.
class CustomUser(AbstractUser):
    user_id = models.UUIDField(default=uuid.uuid4, unique=True, primary_key=True, editable=False)
    email = models.EmailField(unique=True, 
                             )
    user_type = models.CharField(max_length=10, default='patient', choices = [
            ('patient', 'patient'),
            ('doctor', 'doctor'),
            ('pharmacist', 'pharmacist')
        ])
    image = models.ImageField(upload_to='images/', default='default.jpg')

    
    def __str__(self):
        return f"{self.username}"

class Patient(models.Model):
    patient_id = models.UUIDField(default=uuid.uuid4, unique=True, primary_key=True, editable=False)
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    gender = models.CharField(max_length=6, default='', choices=[
        ('male', 'Male'),
        ('female', 'Female')
    ])
    address = models.TextField(blank=True)
    dob = models.DateField(null=True, blank=True)
    phone = models.CharField(max_length=15)

    def __str__(self):
        return f"{self.user.username}"
    
