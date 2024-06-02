import qrcode
from io import BytesIO
import base64
from django.core.mail import send_mail, EmailMultiAlternatives
from django.shortcuts import render
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import (ListCreateAPIView, ListAPIView, 
                                     RetrieveUpdateDestroyAPIView, UpdateAPIView)

from accounts.models import Patient
from . models import Drug, Prescription
from . serializers import (DrugSerializer, PrescriptionSerializer, DrugPrescribedSerializer,
                           FullPrescriptionSerializer, FullDrugPrescribedSerializer,
                           PaymentStatusUpdateSerializer)
# Create your views here.

class DrugsView(ListCreateAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

class DrugsModView(RetrieveUpdateDestroyAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

def generate_qr(prescription_id):
    qr_content = f'{prescription_id}'
    qr_image = qrcode.make(qr_content, box_size=5)
    stream = BytesIO()
    qr_image.save(stream, format='PNG')  # Save the image directly to BytesIO
    qr_image_data = stream.getvalue()

    return qr_image_data

def generate_save_qr(id):
    qr_image = qrcode.make(id, box_size=2)
    # qr_image = qrcode.make(certificate.serial_number, box_size=5)
    qr_image_pil = qr_image.get_image()
    stream = BytesIO()
    qr_image_pil.save(stream, format='PNG')
    qr_image_data = stream.getvalue()
    qr_image_base64 = base64.b64encode(qr_image_data).decode('utf-8')
    return qr_image_base64

def send_qr_code_email(patient_id, prescription_id):
    patient = Patient.objects.get(patient_id=patient_id)
    qr_image_data = generate_qr(prescription_id)

    subject = 'QR Prescription'
    context = {'patient_name': patient.user.first_name}
    html_message = render_to_string('email/qrcode_email.html', context)
    plain_message = strip_tags(html_message)  # Strip HTML tags for the plain text version
    from_email = 'ademolabello519@gmail.com'  # Replace with your email address
    to_email = patient.user.email
    
    # Attach the QR code image to the email
    email = EmailMultiAlternatives(subject, plain_message, from_email, [to_email])
    email.attach_alternative(html_message, "text/html")
    email.attach('qr_code.png', qr_image_data, 'image/png')
    
    email.send()

class PrescriptionView(ListCreateAPIView):
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request):
        data = request.data
        # extract drug_prescribed_data
        drug_pres_data = data.pop('drug_prescribed', [])
        print(f"data now: {data}")
        print(f"drug_pre: {drug_pres_data}")

        prescription_serializer = PrescriptionSerializer(data=data)
        if prescription_serializer.is_valid():
            prescription_instance = prescription_serializer.save(total=0.0)

            total = 0.0
            for dp_data in drug_pres_data:
                dp_data['prescription'] = prescription_instance.pk
                dp_serializer = DrugPrescribedSerializer(data=dp_data)
                if dp_serializer.is_valid():
                    dp_instance = dp_serializer.save()
                    total += dp_instance.total
                else:
                    return Response(dp_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
                
            prescription_instance.doctor = request.user
            prescription_instance.total = total
            prescription_instance.qr_image = generate_save_qr(prescription_instance.pres_id)
            prescription_instance.save()
            
            # create qrcode and send to user email
            send_qr_code_email(patient_id=data['patient'], prescription_id=prescription_instance.pres_id)
     
            return Response(prescription_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(prescription_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
class PrescriptionList(ListAPIView):
    queryset = Prescription.objects.all()
    serializer_class = FullPrescriptionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        pres_id = self.kwargs.get('prescription_id')
        if pres_id:
            return Prescription.objects.filter(pres_id=pres_id)
        else:
            return Prescription.objects.filter(patient = self.request.user.patient)

    def list(self, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.serializer_class(queryset, many=True)

        for prescription_data in serializer.data:
            prescription_id = prescription_data['pres_id']
            drug_prescribed_data = self.get_drugs_prescribed(prescription_id)
            prescription_data['drug_prescribed'] = drug_prescribed_data

        return Response(serializer.data)
    
    def get_drugs_prescribed(self, prescription_id):
        pres = Prescription.objects.get(pres_id=prescription_id)
        drugs_prescribed = pres.drugs_prescribed.all()
        drug_prescribed_serializer = FullDrugPrescribedSerializer(drugs_prescribed, many=True)
        return drug_prescribed_serializer.data


    # def get(self, *args, **kwargs):
    #     if not self.request.user.user_type == "patient":
    #         return Response({"error": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        
    #     # try:
    #     prescriptions = Prescription.objects.filter(patient = self.request.user.patient)
    #     # prescriptions = Prescription.objects.all()
    #     print(prescriptions)
    #     serializer = self.get_serializer(prescriptions)
    #     # serializer.is_valid(raise_exception=True)
    #     return Response(serializer.data, status=status.HTTP_200_OK)
    #     # except:
    #     #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

class PrescriptionUpdatePaymentStatusView(UpdateAPIView):
    queryset = Prescription.objects.all()
    serializer_class = PaymentStatusUpdateSerializer
    permission_classes = [IsAuthenticated]

    # def update()

