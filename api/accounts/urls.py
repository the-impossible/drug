from django.urls import path, include

from . views import (CustomRegisterView, UpdateUserView, RetrieveUserDetail, 
                     RetrievePatientDetail, RetrievePatientDetailId)
urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('register/', CustomRegisterView.as_view(), name="register"),
    path('user/update/', UpdateUserView.as_view(), name="update_user"),
    path('user/<str:username>/', RetrieveUserDetail.as_view(), name="retrieve_user"),
    path('user/<str:username>/', RetrieveUserDetail.as_view(), name="retrieve_user"),
    path('patient/', RetrievePatientDetail.as_view(), name="retrieve_patient"),
    path('patient/<str:username>/', RetrievePatientDetailId.as_view(), name="retrieve_patient"),
]
