package com.imyuewang.EduCity.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.regex.Pattern;

/**
 * @ClassName MailUtils
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/19 13:39
 **/

@Component
public class MailUtil {
    @Value("${mail.user}")
    private String USER; // Sender's email address
    @Value("${mail.password}")
    private String PASSWORD; // If it is a qq mailbox you can make the authorization code on the client side

    public boolean isEmail(String email) {
        if (email == null || email.length() < 1 || email.length() > 256) {
            return false;
        }
        Pattern pattern = Pattern.compile("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$");
        return pattern.matcher(email).matches();
    }

    /**
     * send email
     * @param userEmail Recipient Email
     * @param text Mail body
     * @param title Mail title
     */
    public boolean sendMail(String userEmail, String text, String title){
        try {
            final Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.host", "smtp.qq.com");

            // sender's account
            props.put("mail.user", USER);
            // sender's password
            props.put("mail.password", PASSWORD);

            // Construct authorization information for SMTP for authentication
            Authenticator authenticator = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    // username\password
                    String userName = props.getProperty("mail.user");
                    String password = props.getProperty("mail.password");
                    return new PasswordAuthentication(userName, password);
                }
            };
            // Create email sessions using environmental attributes and authorization information
            Session mailSession = Session.getInstance(props, authenticator);
            // Create an email message
            MimeMessage message = new MimeMessage(mailSession);
            // Setting the sender
            String gameEmail = props.getProperty("mail.user");
            InternetAddress form = new InternetAddress(gameEmail);
            message.setFrom(form);

            // Setting the recipient
            InternetAddress to = new InternetAddress(userEmail);
            message.setRecipient(Message.RecipientType.TO, to);

            // Set the email title
            message.setSubject(title);

            // Set the content body of the email
            message.setContent(text, "text/html;charset=UTF-8");
            // Send an email
            Transport.send(message);
            return true;
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

}
