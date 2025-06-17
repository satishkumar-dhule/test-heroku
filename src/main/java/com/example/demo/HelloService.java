package com.example.demo;

public class HelloService {
    public String getGreeting(String name) {
        return String.format("Hello, %s!", name);
    }

    public String getWelcomeMessage() {
        return "Welcome to our demo application!";
    }
}
