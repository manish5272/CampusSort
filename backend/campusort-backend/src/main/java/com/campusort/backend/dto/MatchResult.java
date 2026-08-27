package com.campusort.backend.dto;

import java.util.List;

public class MatchResult {

    private Double matchPercentage;
    private List<String> matchedSkills;
    private List<String> missingSkills;

    public MatchResult(Double matchPercentage,
                       List<String> matchedSkills,
                       List<String> missingSkills) {

        this.matchPercentage = matchPercentage;
        this.matchedSkills = matchedSkills;
        this.missingSkills = missingSkills;
    }

    public Double getMatchPercentage() {
        return matchPercentage;
    }

    public List<String> getMatchedSkills() {
        return matchedSkills;
    }

    public List<String> getMissingSkills() {
        return missingSkills;
    }
}