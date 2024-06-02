from django.urls import path

from . views import DrugsView, DrugsModView, PrescriptionView, PrescriptionList, PrescriptionUpdatePaymentStatusView

urlpatterns = [
    path('drugs/', DrugsView.as_view(), name="drugs"),
    path('drugs/<str:pk>/', DrugsModView.as_view(), name="drugs_modify"),
    path('prescribe/', PrescriptionView.as_view(), name="prescription"),
    path('prescriptions/', PrescriptionList.as_view(), name="prescription_list"),
    path('prescriptions/<uuid:prescription_id>/', PrescriptionList.as_view(), name="prescription_list"),
    path('prescription/<uuid:pk>/payment/', PrescriptionUpdatePaymentStatusView.as_view(), name="prescription_list"),
]
