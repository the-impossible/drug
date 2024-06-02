from django.shortcuts import render
from rest_framework.exceptions import NotFound
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.authtoken.models import Token

from . models import CustomUser, Patient
from . serializers import (CustomRegisterSerializer, PatientSerializer,
                           PatientUpdateSerializer, UserDetailsSerializer)
# Create your views here.
class CustomRegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomRegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        print(f"SERIALIZER: {user}")
        return Response(user, status=status.HTTP_201_CREATED)

class UpdateUserView(generics.UpdateAPIView):
    serializer_class = PatientUpdateSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        try:
            return self.request.user.patient
        except:
            user = self.request.user
            patient = Patient.objects.create(user=user)
            return patient

class RetrievePatientDetail(generics.RetrieveAPIView):
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        user = self.request.user
        try:
            # try to retrieve the patient associated with the current user
            return Patient.objects.get(user=user)
        except Patient.DoesNotExist:
            # If the patient does not exist, raise a NotFound exception
            raise NotFound("Patient details not found")

class RetrieveUserDetail(generics.RetrieveAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = UserDetailsSerializer
    permission_classes = [IsAuthenticated]

    def get(self, *args, **kwargs):
        username = self.kwargs.get('username')
        try:
            user = CustomUser.objects.get(username=username)
            serializer = self.get_serializer(user)
            return Response(serializer.data)
        except:
            return Response({"error": "Not Record found"}, status=status.HTTP_404_NOT_FOUND)

class RetrievePatientDetailId(generics.RetrieveAPIView):
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer
    permission_classes = [IsAuthenticated]

    def get(self, *args, **kwargs):
        if not self.request.user.user_type == "doctor":
            return Response({"error": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)

        username = self.kwargs.get('username')
        try:
            patient = Patient.objects.get(user__username=username)
            serializer = self.get_serializer(patient)
            return Response(serializer.data)
        except:
            return Response({"error": "Not Record found"}, status=status.HTTP_404_NOT_FOUND)


