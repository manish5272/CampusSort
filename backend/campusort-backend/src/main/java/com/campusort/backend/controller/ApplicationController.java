package com.campusort.backend.controller;

import com.campusort.backend.entity.Application;
import com.campusort.backend.repository.ApplicationRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/applications")
public class ApplicationController {

    private final ApplicationRepository applicationRepository;

    public ApplicationController(ApplicationRepository applicationRepository) {
        this.applicationRepository = applicationRepository;
    }

    @GetMapping
    public List<Application> getApplications() {
        return applicationRepository.findAll();
    }


    @GetMapping("/student/{studentId}")
    public List<Application> getStudentApplications(
            @PathVariable Long studentId) {

        return applicationRepository.findByStudentId(studentId);
    }

    @PutMapping("/{id}/status")
    public Application updateStatus(
            @PathVariable Long id,
            @RequestParam String status) {

        Application application =
                applicationRepository.findById(id).orElse(null);

        if (application == null) {
            return null;
        }

        application.setStatus(status);

        return applicationRepository.save(application);
    }


    @GetMapping("/job/{jobId}")
    public List<Application> getJobApplications(
            @PathVariable Long jobId) {

        return applicationRepository.findByJobId(jobId);
    }

    @PostMapping
    public Application apply(@RequestBody Application application) {
        application.setStatus("APPLIED");
        return applicationRepository.save(application);
    }
}