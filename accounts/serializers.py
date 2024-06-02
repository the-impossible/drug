import base64
from django.contrib.auth import get_user_model
from django.core.files.storage import default_storage
import django.contrib.auth.password_validation as validators
from django.core import exceptions
from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from dj_rest_auth.serializers import (UserDetailsSerializer)
from . models import CustomUser, Patient
from rest_framework.authtoken.models import Token


class CustomRegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required = True,
                                   validators= [UniqueValidator(queryset=get_user_model().objects.all(), message= 'A User with that email Already Exists')])

    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = [
            'username',
            'email',
            'password1',
            'password2'
        ]

    def validate(self, attrs):
        password1 = attrs.get('password1')
        password2 = attrs.get('password2')
        errors = dict()

        if password1 != password2:
            raise serializers.ValidationError({"password2": "The two password fields didn't match."})

        try:
            validators.validate_password(password=password1)
        except exceptions.ValidationError as e:
            errors['password1'] = list(e.messages)

        if errors:
            raise serializers.ValidationError(errors)

        return super().validate(attrs)


    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password1']
        )

        user.save()
        token, _ = Token.objects.get_or_create(user=user)
        
        print(f"TOKE: {token}")
        print(f"TOKE: {token.key}")

        user_response = {
            'username': user.username,
            'email': user.email,
            'token': token.key
        }

        return user_response


class UserDetailsSerializer(UserDetailsSerializer):

    image_mem = serializers.SerializerMethodField("image_memory")

    class Meta(UserDetailsSerializer.Meta):
        fields = [
            'pk',
            'username',
            'email',
            'first_name',
            'last_name',
            'user_type',
            'image_mem',
        ]

    def image_memory(request, model:CustomUser):
        if model.image.name is not None:
            with default_storage.open(model.image.name, 'rb') as loadedfile:
                return base64.b64encode(loadedfile.read())

class PatientSerializer(serializers.ModelSerializer):
    user = UserDetailsSerializer()
    class Meta:
        model = Patient
        fields = [
            "user",
            "pk",
            "address",
            "dob",
            "phone",
            "gender"
        ]

class UpdateUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = [
            "last_name",
            "first_name",
        ]

class PatientUpdateSerializer(serializers.ModelSerializer):
    user = UpdateUserSerializer()
    class Meta:
        model = Patient
        fields = [
            'user',
            'phone',
            'gender',
            'address',
            'dob'
        ]


    def update(self, instance, validated_data):
        user_data = validated_data.pop('user')
        user = instance.user

        for key, value in user_data.items():
            setattr(user, key, value)

        user.save()

        instance.phone = validated_data.get('phone', instance.phone)
        instance.gender = validated_data.get('gender', instance.gender)
        instance.address = validated_data.get('address', instance.address)
        instance.dob = validated_data.get('dob', instance.dob)

        instance.save()

        return instance