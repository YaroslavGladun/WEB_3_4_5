from django.db import models


class User(models.Model):
    name = models.CharField(max_length=255)
    surname = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    registration_date = models.DateField()
    birth_date = models.DateField()

    def __str__(self):
        return self.email


class Photo(models.Model):
    photo_path = models.URLField()
    title = models.CharField(max_length=512)
    description = models.CharField(max_length=2048)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    post_date_time = models.DateTimeField()

    def __str__(self):
        return self.title


class Comment(models.Model):
    text = models.CharField(max_length=2048)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE)
    post_date_time = models.DateTimeField()

    def __str__(self):
        return self.text
