package com.example.demo;

import org.junit.Test;
import static org.junit.Assert.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.io.StringWriter;
import static org.mockito.Mockito.*;

public class HelloServletTest {
    
    @Test
    public void testDoGet() throws Exception {
        // Arrange
        HelloServlet servlet = new HelloServlet();
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        
        when(response.getWriter()).thenReturn(writer);
        
        // Act
        servlet.doGet(request, response);
        
        // Assert
        verify(response).setContentType("text/html");
        String output = stringWriter.toString();
        assertTrue("Response should contain welcome message", 
            output.contains("Welcome to our demo application!"));
    }
}
