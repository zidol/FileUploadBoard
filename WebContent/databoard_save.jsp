<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*, java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		/* String fileurl = "/Users/zidol/workspace/Ch11Test/WebContent/upload/"; */
		String saveFolder = "/upload";
		ServletContext context = getServletContext();
		String fileurl = context.getRealPath(saveFolder);
		
		String encType = "utf-8";
		int maxsize = 5*1024*1024;
		
		try {
			
			MultipartRequest multi = new MultipartRequest(request, fileurl, maxsize, encType, new DefaultFileRenamePolicy());
			
			String name = multi.getParameter("name");
			String email = multi.getParameter("email");
			String subject = multi.getParameter("subject");
			String content = multi.getParameter("content");
			String password = multi.getParameter("password");
			int id = 1;
			int pos = 0;
			
			if(content.length() == 1)
				content += " ";
	
			
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
		    	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dboard?useSSL=false", "multi", "1234");
				st = con.createStatement();
				sql = "select max(id) from databoard";
				rs = st.executeQuery(sql);
				if(!(rs.next())) {
					id = 1;
				} else {
					id = rs.getInt(1) + 1;
					rs.close();
				}
				
				Enumeration files = multi.getFileNames();
				String filename = "";
				String fname = (String)files.nextElement();
				filename = (String)multi.getFilesystemName(fname);
				File file = multi.getFile(fname);
				
				if(filename != null) {
					String original = multi.getOriginalFileName(fname);
					String type = multi.getContentType(fname);
					sql = "insert into databoard(id,name,password,email,subject,content,inputdate,masterid,readcount,replynum,step,filename, filesize)";
					sql += " values(?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 0, ?, ?)";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(9, filename);
					pstmt.setInt(10, (int)file.length());
				} else {
					sql = "insert into databoard(id,name,password,email,subject,content,inputdate,masterid,readcount,replynum,step,filename, filesize)";
					sql += " values(?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 0, ' ', 0)";
					pstmt = con.prepareStatement(sql);
				}
				
				pstmt.setInt(1, id);
				pstmt.setString(2, name);
				pstmt.setString(3, password);
				pstmt.setString(4, email);
				pstmt.setString(5, subject);
				pstmt.setString(6, content);
				pstmt.setString(7, ymd);
				pstmt.setInt(8, id);
				
				cnt = pstmt.executeUpdate();
				/* cnt = st.executeUpdate(sql); */
				
				if(cnt>0) {
					if(filename != null) {
						out.println("<script> alert('데이터가 성공적으로 입력되었습니다.'); location.href='databoard_list.jsp';</script>");
					} else {
						out.println("<script> alert('업로드파일은 없으며 글은 업로드되었습니다.'); location.href='databoard_list.jsp';</script>");
					}
				} else {
					out.println("<script> alert('데이터가 성공적으로 입력되지 않았습니다.'); history.go(-1);</script>");	
				}
			} catch (SQLException e) {
				out.println(e);
			} finally{
				/* st.close(); */
				if(pstmt != null)try{ pstmt.close();} catch (SQLException e) {}
				if(con != null)try{con.close();} catch(SQLException e){} 
			}
		} catch (IOException ioe) {
			out.println(ioe);
		}
	%>
	<!-- <br><a href="freeboard_write.html">[글 올리는 곳으로]</a> -->
</body>
</html>