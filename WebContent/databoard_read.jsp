<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 내용 보기</title>
<link href="filegb.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	%>
	<%
		String sql = null;
		Connection con = null;
		PreparedStatement st = null;
		ResultSet rs = null;

		int id = Integer.parseInt(request.getParameter("id"));
		
		String saveFolder = "/upload";
		ServletContext context = getServletContext();
		String url = context.getRealPath(saveFolder);

		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			out.println(e);
		}

		try {
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dboard?useSSL=false", "multi", "1234");
		} catch (SQLException e) {
			out.println(e);
		}

		try {
			sql = "select * from databoard where id=?";
			st = con.prepareStatement(sql);
			st.setInt(1, id);
			rs = st.executeQuery();

			if (!rs.next()) {
				out.println("해당 내용이 없습니다");
			} else {
				String finame = rs.getString("filename");
				if(finame != null && !(finame.equals(""))){
					finame = "<a href=down.jsp?file=" + finame +">" + finame + "</a>";
					finame = finame +" ( " + rs.getInt("filesize") + " Bytes)";
				}
				
				String em = rs.getString("email");
				if ((em != null) && (!(em.equals(""))))
					em = "<a href=mailto:" + em + ">" + rs.getString("name") + "</A>";
				else
					em = rs.getString("name");
				out.println("<div align='center'>");
				out.println("<table width='600' cellspacing='0' cellpadding='2'>");
				out.println("<tr>");
				out.println("<td height='22'>&nbsp;</td></tr>");
				out.println("<tr align='center'>");
				out.println("<td height='1' bgcolor='#1F4F8F'></td>");
				out.println("</tr>");
				out.println("<tr align='center' bgcolor='#DFEDFF'>");
				out.println("<td class='button' bgcolor='#DFEDFF'>");
				out.println("<div align='left'><font size='2'>" + rs.getString("subject") + "</div> </td>");
				out.println("</tr>");
				out.println("<tr align='center' bgcolor='#FFFFFF'>");
				out.println("<td align='center' bgcolor='#F4F4F4'>");
				out.println("<table width='100%' border='0' cellpadding='0' cellspacing='4' height='1'>");
				out.println("<tr bgcolor='#F4F4F4'>");
				out.println("<td width='13%' height='7'></td>");
				out.println("<td width='51%' height='7'>글쓴이 : " + em + "</td>");
				out.println("<td width='51%' height='7'>파일 이름 : " + finame + "</td>");
				out.println("<td width='25%' height='7'></td>");
				out.println("<td width='11%' height='7'></td>");
				out.println("</tr>");
				out.println("<tr bgcolor='#F4F4F4'>");
				out.println("<td width='13%'></td>");
				out.println("<td width='51%'>작성일 : " + rs.getString("inputdate") + "</td>");
				out.println("<td width='25%'>조회 : " + rs.getInt("readcount") + "</td>");
				out.println("<td width='11%'></td>");
				out.println("</tr>");
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
				out.println("<tr align='center'>");
				out.println("<td bgcolor='#1F4F8F' height='1'></td>");
				out.println("</tr>");
				out.println("<tr align='center'>");
				out.println("<td style='padding:10 0 0 0'>");
				out.println("<div align='left'><br>");
				out.println("<font size='3' color='#333333'><pre>" + rs.getString("content") + "</pre></div>");
				out.println("<br>");
				out.println("</td>");
				out.println("</tr>");
				out.println("<tr align='center'>");
				out.println("<td class='button' height='1'></td>");
				out.println("</tr>");
				out.println("<tr align='center'>");
				out.println("<td bgcolor='#1F4F8F' height='1'></td>");
				out.println("</tr>");
				out.println("</table>");
				out.println("</div>");
	%>
	<div align="center">
		<table width="600" border="0" cellpadding="0" cellspacing="5">
			<tr>
				<td align="right" width="450"><a
					href="databoard_list.jsp?go=<%=request.getParameter("page")%>">
						<img src="image/list.jpg" border=0>
				</a></td>
				<td width="70" align="right"><a
					href="databoard_rwrite.jsp?id=<%=request.getParameter("id")%>&page=<%=request.getParameter("page")%>">
						<img src="image/reply.jpg" border=0>
				</a></td>
				<td width="70" align="right"><a
					href="databoard_upd.jsp?id=<%=id%>&page=1"> <img
						src="image/edit.jpg" border=0></a></td>
				<td width="70" align="right"><a
					href="databoard_del.jsp?id=<%=id%>&page=1"> <img
						src="image/del.jpg" border=0></a></td>
			</tr>
		</table>
	</div>
	<%
		sql = "update databoard set readcount= readcount + 1 where id=?";
				st = con.prepareStatement(sql);
				st.setInt(1, id);
				st.executeUpdate();
			}
			rs.close();
			st.close();
			con.close();
		} catch (SQLException e) {
			out.println(e);
		}
	%>

</body>
</html>