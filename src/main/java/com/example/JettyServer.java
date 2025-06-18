package com.example;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import com.example.demo.HelloServlet;

public class JettyServer {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));
        Server server = new Server(port);

        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");
        // Register your servlet(s) here
        context.addServlet(new ServletHolder(HelloServlet.class), "/hello");

        server.setHandler(context);
        server.start();
        server.join();
    }
}
