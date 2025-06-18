package com.example.demo;

import org.junit.Test;
import static org.junit.Assert.*;

public class HelloServiceTest {
    
    @Test
    public void testGetWelcomeMessage() {
        HelloService service = new HelloService();
        String message = service.getWelcomeMessage();
        assertNotNull("Message should not be null", message);
        assertTrue("Message should not be empty", message.length() > 0);
    }
    
    @Test
    public void testGetGreeting() {
        HelloService service = new HelloService();
        String message = service.getGreeting("Test User");
        assertNotNull("Greeting should not be null", message);
        assertTrue("Greeting should contain the name", message.contains("Test User"));
    }
}
