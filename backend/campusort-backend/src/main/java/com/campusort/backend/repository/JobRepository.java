package com.campusort.backend.repository;

import com.campusort.backend.entity.Job;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface JobRepository extends JpaRepository<Job, Long> {

    @Query(value = """
        SELECT
        (COUNT(DISTINCT CASE
            WHEN ss.skill_id = js.skill_id THEN js.skill_id
        END) * 100.0 / COUNT(DISTINCT js.skill_id))
        FROM job_skills js
        LEFT JOIN student_skills ss
            ON js.skill_id = ss.skill_id
            AND ss.student_id = :studentId
        WHERE js.job_id = :jobId
        AND js.is_required = true
        """, nativeQuery = true)
    Double calculateMatch(
            @Param("studentId") Long studentId,
            @Param("jobId") Long jobId
    );

    @Query(value = """
        SELECT s.skill_name
        FROM student_skills ss
        JOIN skills s ON ss.skill_id = s.id
        WHERE ss.student_id = :studentId
        """, nativeQuery = true)
    List<String> getStudentSkills(
            @Param("studentId") Long studentId
    );


    @Query(value = """
    SELECT s.skill_name
    FROM job_skills js
    JOIN skills s ON js.skill_id = s.id
    WHERE js.job_id = :jobId
    AND js.is_required = true
    """, nativeQuery = true)
    List<String> getJobRequiredSkills(
            @Param("jobId") Long jobId
    );
}