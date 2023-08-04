package com.imyuewang.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Date;

/**
 * 
 * @TableName takenmapcell
 */
@Data
public class Takenmapcell implements Serializable {
    /**
     * 
     */
    @TableId(value = "mapid")
    private Long mapid;

    /**
     * 
     */
    @TableField(value = "positionx")
    private Integer positionx;

    /**
     * 
     */
    @TableField(value = "positiony")
    private Integer positiony;

    /**
     * 
     */
    @TableField(value = "housetype")
    private Integer housetype;

    /**
     * 
     */
    @TableField(value = "finishtime")
    private Long finishtime;

    private static final long serialVersionUID = 1L;

    /**
     * 
     */
    public Long getMapid() {
        return mapid;
    }

    /**
     * 
     */
    public void setMapid(Long mapid) {
        this.mapid = mapid;
    }

    /**
     * 
     */
    public Integer getPositionx() {
        return positionx;
    }

    /**
     * 
     */
    public void setPositionx(Integer positionx) {
        this.positionx = positionx;
    }

    /**
     * 
     */
    public Integer getPositiony() {
        return positiony;
    }

    /**
     * 
     */
    public void setPositiony(Integer positiony) {
        this.positiony = positiony;
    }

    /**
     * 
     */
    public Integer getHousetype() {
        return housetype;
    }

    /**
     * 
     */
    public void setHousetype(Integer housetype) {
        this.housetype = housetype;
    }

    /**
     * 
     */
    public Long getFinishtime() {
        return finishtime;
    }

    /**
     * 
     */
    public void setFinishtime(Long finishtime) {
        this.finishtime = finishtime;
    }

    @Override
    public boolean equals(Object that) {
        if (this == that) {
            return true;
        }
        if (that == null) {
            return false;
        }
        if (getClass() != that.getClass()) {
            return false;
        }
        Takenmapcell other = (Takenmapcell) that;
        return (this.getMapid() == null ? other.getMapid() == null : this.getMapid().equals(other.getMapid()))
            && (this.getPositionx() == null ? other.getPositionx() == null : this.getPositionx().equals(other.getPositionx()))
            && (this.getPositiony() == null ? other.getPositiony() == null : this.getPositiony().equals(other.getPositiony()))
            && (this.getHousetype() == null ? other.getHousetype() == null : this.getHousetype().equals(other.getHousetype()))
            && (this.getFinishtime() == null ? other.getFinishtime() == null : this.getFinishtime().equals(other.getFinishtime()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getMapid() == null) ? 0 : getMapid().hashCode());
        result = prime * result + ((getPositionx() == null) ? 0 : getPositionx().hashCode());
        result = prime * result + ((getPositiony() == null) ? 0 : getPositiony().hashCode());
        result = prime * result + ((getHousetype() == null) ? 0 : getHousetype().hashCode());
        result = prime * result + ((getFinishtime() == null) ? 0 : getFinishtime().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", mapid=").append(mapid);
        sb.append(", positionx=").append(positionx);
        sb.append(", positiony=").append(positiony);
        sb.append(", housetype=").append(housetype);
        sb.append(", finishtime=").append(finishtime);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }


}