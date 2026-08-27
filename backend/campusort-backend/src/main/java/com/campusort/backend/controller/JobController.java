package com.campusort.backend.controller;
import com.campusort.backend.dto.MatchResult;
import java.util.List;
import com.campusort.backend.entity.Job;
import com.campusort.backend.repository.JobRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;

@CrossOrigin
@RestController
@RequestMapping("/api/jobs")
public class JobController {

    private final JobRepository jobRepository;

    public JobController(JobRepository jobRepository) {
        this.jobRepository = jobRepository;
    }

    @GetMapping
    public List<Job> getJobs() {
        return jobRepository.findAll();
    }

    @GetMapping("/{id}")
    public Job getJob(@PathVariable Long id) {
        return jobRepository.findById(id).orElse(null);
    }

    @GetMapping("/{jobId}/match/{studentId}")
    public MatchResult getMatch(
            @PathVariable Long jobId,
            @PathVariable Long studentId) {

        List<String> studentSkills =
                jobRepository.getStudentSkills(studentId);

        List<String> jobSkills =
                jobRepository.getJobRequiredSkills(jobId);

        List<String> matchedSkills = jobSkills.stream()
                .filter(studentSkills::contains)
                .toList();

        List<String> missingSkills = jobSkills.stream()
                .filter(skill -> !studentSkills.contains(skill))
                .toList();

        Double percentage = 0.0;

        if (!jobSkills.isEmpty()) {
            percentage =
                    (matchedSkills.size() * 100.0) / jobSkills.size();
        }

        return new MatchResult(
                percentage,
                matchedSkills,
                missingSkills
        );
    }
}