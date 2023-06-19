package com.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName module
 */
@TableName(value ="module")
@Data
public class Module implements Serializable {
    /**
     * 
     */
    @TableId(value = "knowledgeID")
    private Long knowledgeid;

    /**
     * 
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    @TableField(value = "name")
    private String name;

    /**
     * 0-not finished 1-finished
     */
    @TableField(value = "isFinished")
    private Integer isfinished;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;

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
        Module other = (Module) that;
        return (this.getKnowledgeid() == null ? other.getKnowledgeid() == null : this.getKnowledgeid().equals(other.getKnowledgeid()))
            && (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getName() == null ? other.getName() == null : this.getName().equals(other.getName()))
            && (this.getIsfinished() == null ? other.getIsfinished() == null : this.getIsfinished().equals(other.getIsfinished()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getKnowledgeid() == null) ? 0 : getKnowledgeid().hashCode());
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getName() == null) ? 0 : getName().hashCode());
        result = prime * result + ((getIsfinished() == null) ? 0 : getIsfinished().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", knowledgeid=").append(knowledgeid);
        sb.append(", id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", isfinished=").append(isfinished);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}