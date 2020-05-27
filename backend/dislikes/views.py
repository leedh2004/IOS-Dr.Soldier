from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from users import models as user_models
from posts import models as post_models
from . import models as dislike_models

def dislikes(request):
    post_pk = request.GET.get("pk")
    email = request.GET.get("user")
    user = user_models.User.objects.get(username=email)
    post = post_models.Post.objects.get(pk=post_pk)
    print("dislike")
    try:
        dislike_check = dislike_models.Dislike.objects.get(user=user, post=post)
        dislike_check.delete()
        return HttpResponse("ok")
    except dislike_models.Dislike.DoesNotExist:
        dislike = dislike_models.Dislike.objects.create(user=user, post=post)
        dislike.save()
        return HttpResponse("ok")