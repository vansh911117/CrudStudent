<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<table align="center" border="1px">
<th>Id</th>
<th>Name</th>
<th>Sal</th>
<c:forEach var="i" items="${data }" >
<tr>
	<form action="update">
	<td>${i.getId()}<input type="hidden" name="id" value="${i.getId()}" /></td>
	<td><input type="text" name="name" value="${i.getName()}" /></td>
	<td><input type="number" name="sal" value="${i.getSal()}" /></td>
	<td><input type="submit" value="Update" /></td>
	</form>
	<td><a href="deletepro?id=${i.getId()}">Delete</a></td>
</tr>
</c:forEach>
</table>