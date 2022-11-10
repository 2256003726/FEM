package com.wjp.fem.dao;

import com.wjp.fem.bean.User;
import com.wjp.fem.bean.UserExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    long countByExample(UserExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int deleteByExample(UserExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int deleteByPrimaryKey(String userId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int insert(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int insertSelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    List<User> selectByExample(UserExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    User selectByPrimaryKey(String userId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByExampleSelective(@Param("record") User record, @Param("example") UserExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByExample(@Param("record") User record, @Param("example") UserExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByPrimaryKeySelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_user
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByPrimaryKey(User record);
}