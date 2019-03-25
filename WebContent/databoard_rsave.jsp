<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답글 처리</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		String password = request.getParameter("password");
		int mid = Integer.parseInt(request.getParameter("mid"));
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		int step = Integer.parseInt(request.getParameter("step"))+1;
		int id = 0;
		int pos = 0;
		
		if(content.length() == 1)
			content += " ";

		//Statement 객체를사용 - 홑따옴표로 감싼 내용에 DB에 사입되지 않는 문제를 해결
		//PreparedStatement 객체를 사용함으로써 해결
		/* while((pos=content.indexOf("\'", pos)) != -1 ) {
			String left = content.substring(0, pos);
			String right = content.substring(pos, content.length());
			content = left + "\'" + right;
			pos += 2;
		} */
		
		java.util.Date yymmdd = new java.util.Date();
		SimpleDateFormat myformat = new SimpleDateFormat("yy-MM-d h:mm a");
		String ymd = myformat.format(yymmdd);
		
		String sql = null;
		Connection con = null;
		Statement st = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			out.print(e);
		}
		
		try {
	    	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fboard?useSSL=false", "multi", "1234");
			st = con.createStatement();
			sql = "select max(id) from freeboard";
			rs = st.executeQuery(sql);
			if(!(rs.next())) {
				id = 1;
			} else {
				id = rs.getInt(1) + 1;
				rs.close();
			}
			if(step == 1) {
				sql ="select max(replynum) from freeboard where masterid=" + mid;
				rs = st.executeQuery(sql);
				if(!rs.next()){
					rnum = 1;
				} else {
					rnum = rs.getInt(1)+1;
				}
			}
			//Statement 객체 사용 -> 홑따옴표 입력시 문제 발현
			/* 
			sql = "insert into freeboard(id,name,password,email,subject,content,inputdate,masterid,readcount,replynum,step)";
			sql += " values (" + id + ", '" + name + "', '" + password + "', '" + email ;
			sql += "', '" + subject + "', '" + content + "', '" + ymd + "'," + id + "," + "0,0,0)"; */
			sql = "insert into freeboard(id,name,password,email,subject,content,inputdate,masterid,readcount,replynum,step)";
			sql += " values(?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?)";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, id);
			pstmt.setString(2, name);
			pstmt.setString(3, password);
			pstmt.setString(4, email);
			pstmt.setString(5, subject);
			pstmt.setString(6, content);
			pstmt.setString(7, ymd);
			pstmt.setInt(8, mid);
			pstmt.setInt(9, rnum);
			pstmt.setInt(10, step);
			
			cnt = pstmt.executeUpdate();
			/* cnt = st.executeUpdate(sql); */
			
			if(cnt>0)
				out.println("<script> alert('데이터가 성공적으로 입력되었습니다.'); location.href='freeboard_list.jsp';</script>");
			else
				out.println("<script> alert('데이터가 성공적으로 입력되지 않았습니다.'); history.go(-1);</script>");		
		} catch (SQLException e) {
			out.println(e);
		} finally{
			/* st.close(); */
			if(pstmt != null)try{ pstmt.close();} catch (SQLException e) {}
			if(con != null)try{con.close();} catch(SQLException e){} 
		}
		response.sendRedirect("freeboard_list.jsp?go=" + request.getParameter("page"));
	%>
	<!-- <br><a href="freeboard_write.html">[글 올리는 곳으로]</a> -->
</body>
</html>