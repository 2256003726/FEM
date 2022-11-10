package com.wjp.fem.dao;

import com.wjp.fem.bean.RecordElec;
import com.wjp.fem.bean.RecordElecExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface RecordElecMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    long countByExample(RecordElecExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int deleteByExample(RecordElecExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int deleteByPrimaryKey(Long recordElecId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int insert(RecordElec record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int insertSelective(RecordElec record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    List<RecordElec> selectByExample(RecordElecExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    RecordElec selectByPrimaryKey(Long recordElecId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByExampleSelective(@Param("record") RecordElec record, @Param("example") RecordElecExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByExample(@Param("record") RecordElec record, @Param("example") RecordElecExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByPrimaryKeySelective(RecordElec record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table fire_record_elec
     *
     * @mbg.generated Fri Mar 20 13:13:37 GMT+08:00 2020
     */
    int updateByPrimaryKey(RecordElec record);
}