<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.Profile" %>
<%@ page import="com.example.guestbook.Greeting" %>
<%@ page import="com.example.guestbook.Guestbook" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>OurBook</title>
    <link type="text/css" rel="stylesheet" href="/stylesheets/vendor/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
    <link rel="icon" type="image/png" sizes="32x32" href="imgs/favicon-32x32.png">
</head>

<body>

<%
UserService userService = UserServiceFactory.getUserService();
String interest = request.getParameter("interest");
if (interest == null) {
    interest = "";
}
User user = userService.getCurrentUser();
String cur_nickname = "___default__ current nickname";
if (user != null) {
    cur_nickname = user.getNickname();
    if (cur_nickname.contains("@")) {
        cur_nickname = cur_nickname.substring(0, cur_nickname.indexOf("@"));
    }
    cur_nickname = cur_nickname.replace(".","");
    

    pageContext.setAttribute("user", user);
    pageContext.setAttribute("interest", interest);
    pageContext.setAttribute("userEmail", user.getEmail());
    pageContext.setAttribute("cur_nickname", cur_nickname);
%>

<header>
    <nav id="mainHeader" class="nabvar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <a class="navbar-brand" href="/">
                    <img id="logo" class="img-responsive" src="imgs/logo.gif" alt="Logo">
                </a>
            </div>
            <ul class="nav navbar-nav navbar-right collapse navbar-collapse">
                <li>
                    <a href="/guestbook_upd.jsp?pageOwnerNickname=${fn:escapeXml(cur_nickname)}">${fn:escapeXml(user.nickname)}</a>
                </li>
                <li>
                    <a href="/guestbook_upd.jsp?pageOwnerNickname=${fn:escapeXml(cur_nickname)}">Home</a>
                </li>
                <li>
                    <a href="/friendRequests.jsp?pageOwnerNickname=${fn:escapeXml(cur_nickname)}">Friends</a>
                </li>
                <li>
                    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>
                </li>
            </ul>
        </div>
    </nav>
</header>
<body>
    <div class="center userlist">
<%

    List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).list();
    ArrayList<Profile> sameInterests = new ArrayList<Profile>();

    for (Profile profile: profiles) {
      if (profile.user_interests.toLowerCase().contains(interest) && interest.length() > 0 && !profile.user_nickname.equals(cur_nickname)) {
        sameInterests.add(profile);
      }
    }

    if (sameInterests.isEmpty() && interest.length() > 0) {
%>
    <div class="header text-center">
        <h3>You are the only one user with interest in <b>${fn:escapeXml(interest)}</b> :(</h3>
    </div>
<%
    } else if (interest.length() == 0) {
%>
    <div class="header text-center">
        <h3>You did not specify any interest</h3>
    </div>
<%
    } else {
%>
    <div class="header text-center">
        <h3>Users that share your interest in <b>${fn:escapeXml(interest)}</b>:</h3>
    </div>
    <ul>
<%
        for (Profile profile : sameInterests) {
            pageContext.setAttribute("buddy_nickname", profile.user_nickname);
            pageContext.setAttribute("buddy_interest", profile.user_interests);
%>
    <li>
        <h4><a href="/guestbook_upd.jsp?pageOwnerNickname=${fn:escapeXml(buddy_nickname)}">
            <b>${fn:escapeXml(buddy_nickname)}</b>
        </a> is interested in ${fn:escapeXml(buddy_interest)}</h4>
    </li>
<%
        }
%>
    </ul>
<%
    }
%>

    </div>
</body>

<%
} else {
%>

<div class="container text-center">
    <div class="center">
        <div class="header">
            <h1>Welcome to OurBook!</h1>
        </div>
        <div class="form">
            <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
                <button class="btn btn-success">Sign in</button>
            </a>
        </div>
    </div>
</div>


<%
}
%>


</body>
</html>
<%-- //[END all]--%>