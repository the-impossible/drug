from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, Patient

# Register your models here.
class CustomUserAdmin(UserAdmin):
    # Define how the CustomUser model should be displayed in the admin interface
    list_display = ['username', 'email', 'user_type']
    # fieldsets = UserAdmin.fieldsets + (

    #     ('Custom Fields', {'fields': ('user_type')}),
    # )
    search_fields = ['username', 'email']


admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(Patient)