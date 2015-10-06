/*
 * Created on 01 August, 2010
 */
package com.mobilink.SubProcess;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;


/**
 * @author dell
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Login extends HttpServlet {

    DataSource ds = null;

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request,response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = null;
		String passwd = null;
		HttpSession session = request.getSession();
		try {
			if(session != null){
				login = (String)session.getAttribute("login");
				passwd = (String)session.getAttribute("passwd");
			}
			if(login == null || passwd == null){
				login = request.getParameter("login").trim();
				passwd = request.getParameter("passwd").trim();
			}

			boolean authenticated = false;
			if(login != null && passwd != null){
				String pwd=getPwd(login);
			    if(pwd.equals(passwd)) {
			        authenticated = true;
					session.setAttribute("authenticated",""+authenticated);
					RequestDispatcher dispatcher =request.getRequestDispatcher("/welcome.jsp");
					HttpSession Session = request.getSession(true);
                    //System.out.println("loginname: " + login);
                    Session.setAttribute("loginname", login);
                    Session.setAttribute("logname", login);
					if (dispatcher != null) dispatcher.forward(request, response);


				}
			    else {
			        RequestDispatcher dispatcher =request.getRequestDispatcher("./index.jsp");
					if (dispatcher != null) dispatcher.forward(request, response);
			     }
			  }
			}catch(Exception e) {
			    RequestDispatcher dispatcher =request.getRequestDispatcher("./index.jsp");
				if (dispatcher != null) dispatcher.forward(request, response);
			}

		}

    private String getPwd(String login) {

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String pwd=null;
		try{
			ds =getDataSource();
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("select pwd from users where uname=? ");
			pstmt.setString(1, login.trim());
			rs= pstmt.executeQuery();
			if (rs.next()) {
			    pwd=rs.getString(1).trim();
			}
		 return pwd;
		}catch(Exception E){
			E.printStackTrace();
		}finally{
		    try{
		    	 if(rs!=null){
		            rs.close();
		            rs=null;
		            }
		    }catch(Exception e){}
		    try{
		    	if(pstmt!=null){
		            pstmt.close();
		            pstmt=null;
		            }
		    }catch(Exception e){}
		    try{
		      	if(conn!=null){
		            conn.close();
		            conn=null;
		          }
		     }catch(Exception e){}
		 }
		 return pwd;

    }

	public  synchronized DataSource getDataSource(){
		// If data source is not null, return data source
		if (ds != null) {
			return ds;
		}
		try {
			InitialContext cont = new InitialContext();
			ds = (DataSource) cont.lookup("java:HoujeratSubscription");
		} catch (NamingException ne) {

		}
		return ds;

	}

}
