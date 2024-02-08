package pp;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.annotation.Transactional;

public class Edao {

	private JdbcTemplate template;

	public JdbcTemplate getTemplate() {
		return template;
	}

	public void setTemplate(JdbcTemplate template) {
		this.template = template;
	}

	public void saveEmployees(final List<Emp> employeeList) {
		String sql = "INSERT INTO emp (id, name, sal, address, age, dob, phone) VALUES (?, ?, ?, ?, ?, ?, ?)";

		template.batchUpdate(sql, new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Emp employee = employeeList.get(i);
				ps.setString(1, employee.getId());
				ps.setString(2, employee.getName());
				ps.setString(3, employee.getSalary());
				ps.setString(4, employee.getAddress());
				ps.setString(5, employee.getAge());
				ps.setString(6, employee.getDob());
				ps.setString(7, employee.getPhone());
			}

			public int getBatchSize() {
				return employeeList.size();
			}
		});
	}

	public List<Emp> getAllEmployees(int index,String inputText,String selectedOption) {
		System.out.println("Inside getAllEmployees DAO ...index : " + index +" inputText " +inputText);

		index = index * 5;
		StringBuilder builder=new StringBuilder();
		builder.append("%");
		builder.append(inputText);
		builder.append("%");
		String sql="";
		Object[] objects;
		System.out.println(selectedOption);
		if(selectedOption.equalsIgnoreCase("null") || selectedOption.equalsIgnoreCase("age"))
		{
		 sql = "SELECT * FROM emp where name like ? OR sal like ? OR address like ? OR age like ? OR dob like ? OR phone like ?  limit ?,6";
		 objects= new Object[] {builder,builder,builder,builder,builder,builder,index};
		 System.out.println("SQL >>>> " + sql);
		try {
			return template.query(sql,objects, new RowMapper<Emp>() {
				public Emp mapRow(ResultSet rs, int rowNum) throws SQLException {
					Emp emp = new Emp();
					emp.setId(rs.getString("id"));
					emp.setName(rs.getString("name"));
					emp.setSalary(rs.getString("sal"));
					emp.setAddress(rs.getString("address"));
					emp.setAge(rs.getString("age"));
					emp.setDob(rs.getString("dob"));
					emp.setPhone(rs.getString("phone"));
					return emp;
				}
			});
		} catch (Exception e) {
			System.out.println("Error while getting  employee data >>>>");
			e.printStackTrace();
		}
}
		else
		{
			sql = "SELECT * FROM emp where (name like ? OR sal like ? OR address like ? OR dob like ? OR phone like ?) AND age =?  limit ?,6";
			 objects= new Object[] {builder,builder,builder,builder,builder,selectedOption,index};
			 System.out.println("SQL >>>> " + sql);
				try {
					return template.query(sql,objects, new RowMapper<Emp>() {
						public Emp mapRow(ResultSet rs, int rowNum) throws SQLException {
							Emp emp = new Emp();
							emp.setId(rs.getString("id"));
							emp.setName(rs.getString("name"));
							emp.setSalary(rs.getString("sal"));
							emp.setAddress(rs.getString("address"));
							emp.setAge(rs.getString("age"));
							emp.setDob(rs.getString("dob"));
							emp.setPhone(rs.getString("phone"));
							return emp;
						}
					});
				} catch (Exception e) {
					System.out.println("Error while getting  employee data >>>>");
					e.printStackTrace();
				}
		}
		return null;
	}

	public int getTotalCount(String inputText,String selectedOption) {
		StringBuilder builder=new StringBuilder();
		builder.append("%");
		builder.append(inputText);
		builder.append("%");
		String sql="";
		Object[] obj;
		if(selectedOption.equalsIgnoreCase("null") || selectedOption.equalsIgnoreCase("age")) {
		sql = "select count(*) from emp where name like ? OR sal like ? OR address like ? OR age like ? OR dob like ? OR phone like ?";
		 obj=new Object[] {builder,builder,builder,builder,builder,builder}; 
		return template.queryForObject(sql,obj,Integer.class);
		}
		else
		{
			sql = "select count(*) from emp where ( name like ? OR sal like ? OR address like ? OR dob like ? OR phone like ?) AND age=?";
			 obj=new Object[] {builder,builder,builder,builder,builder,selectedOption}; 
			return template.queryForObject(sql,obj,Integer.class);
		}
	}

	public int updateEmp(final Emp emp) {
		String sql = "update emp set name=?,sal=?,address=?,age=?,dob=?,phone=? where id=?";
		return template.update(sql, new PreparedStatementSetter() {
			
			public void setValues(PreparedStatement ps) throws SQLException {
				// TODO Auto-generated method stub
				ps.setString(1, emp.getName());
				ps.setString(2, emp.getSalary());
				ps.setString(3, emp.getAddress());
				ps.setString(4, emp.getAge());
				ps.setString(5, emp.getDob());
				ps.setString(6, emp.getPhone());
				ps.setString(7, emp.getId());

			}

		});

	}
	
	public List<Emp> search(String inputText)
	{
		String sql="select * from emp where name like ? OR sal like ? OR address like ? OR age like ? OR dob like ? OR phone like ?";
		StringBuilder builder=new StringBuilder();
		builder.append("%");
		builder.append(inputText);
		builder.append("%");
		System.out.println(sql);
		
		try {

			return template.query(sql,new Object[] {builder,builder,builder,builder,builder,builder} ,new RowMapper<Emp>() {
				public Emp mapRow(ResultSet rs, int rowNum) throws SQLException {
					Emp emp = new Emp();
					emp.setId(rs.getString("id"));
					emp.setName(rs.getString("name"));
					emp.setSalary(rs.getString("sal"));
					emp.setAddress(rs.getString("address"));
					emp.setAge(rs.getString("age"));
					emp.setDob(rs.getString("dob"));
					emp.setPhone(rs.getString("phone"));
					return emp;
				}
			});
		} catch (Exception e) {
			System.out.println("Error while getting  employee data >>>>");
			e.printStackTrace();
		}
		return null;
	}
	}
	

	/*
	 * public void deletEmp(int id) { String sql="delete from emp where id=?";
	 * template.update(sql, id); }
	 * 
	 */

