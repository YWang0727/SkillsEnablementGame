package com.imyuewang.EduCity.model.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 
 * @TableName user_quiz
 */
@TableName(value ="user_quiz")
@Data
public class UserQuiz implements Serializable {
    /**
     * 
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 
     */
    @TableField(value = "quizId")
    private Integer quizid;

    /**
     * 
     */
    @TableField(value = "knowledgeId")
    private Integer knowledgeid;


    /**
     * 
     */
    @TableField(value = "attempts")
    private Integer attempts;

    /**
     * 
     */
    @TableField(value = "topScore")
    private Integer topscore;

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
        UserQuiz other = (UserQuiz) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getQuizid() == null ? other.getQuizid() == null : this.getQuizid().equals(other.getQuizid()))
            && (this.getKnowledgeid() == null ? other.getKnowledgeid() == null : this.getKnowledgeid().equals(other.getKnowledgeid()))
            && (this.getAttempts() == null ? other.getAttempts() == null : this.getAttempts().equals(other.getAttempts()))
            && (this.getTopscore() == null ? other.getTopscore() == null : this.getTopscore().equals(other.getTopscore()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getQuizid() == null) ? 0 : getQuizid().hashCode());
        result = prime * result + ((getKnowledgeid() == null) ? 0 : getKnowledgeid().hashCode());
        result = prime * result + ((getAttempts() == null) ? 0 : getAttempts().hashCode());
        result = prime * result + ((getTopscore() == null) ? 0 : getTopscore().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", quizid=").append(quizid);
        sb.append(", knowledgeid=").append(knowledgeid);
        sb.append(", attempts=").append(attempts);
        sb.append(", topscore=").append(topscore);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}