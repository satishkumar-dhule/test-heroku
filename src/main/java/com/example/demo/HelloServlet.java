package com.example.demo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    private final HelloService helloService = new HelloService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String greeting = name != null ? 
            helloService.getGreeting(name) : 
            helloService.getWelcomeMessage();
        
        resp.setContentType("text/html");
        resp.getWriter().write("<html><body>" + greeting + "</body></html>");
    }
}
