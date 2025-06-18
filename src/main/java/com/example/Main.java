package com.example;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class Main {
    public static void main(String[] args) throws Exception {
        Server server = new Server(Integer.parseInt(System.getenv().getOrDefault("PORT", "8080")));
        WebAppContext context = new WebAppContext();
        context.setContextPath("/");
        context.setWar("src/main/webapp");
        server.setHandler(context);
        server.start();
        server.join();
    }
}
