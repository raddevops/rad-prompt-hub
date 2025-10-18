#!/usr/bin/env python3
"""
Test script to validate GitHub Actions workflow configurations.

This script checks:
1. All PR workflows have timeout-minutes configured
2. Steps with continue-on-error have proper outcome checking
3. YAML syntax is valid
"""

import yaml
import sys
from pathlib import Path

def load_workflow(path):
    """Load and parse a workflow YAML file."""
    with open(path) as f:
        return yaml.safe_load(f)

def check_timeouts(workflow, path):
    """Check that all jobs have timeout-minutes configured."""
    issues = []
    jobs = workflow.get('jobs', {})
    
    for job_name, job_config in jobs.items():
        if 'timeout-minutes' not in job_config:
            issues.append(f"{path}: Job '{job_name}' missing timeout-minutes")
    
    return issues

def check_continue_on_error_logic(workflow, path):
    """Check that steps with continue-on-error have proper outcome checking."""
    issues = []
    jobs = workflow.get('jobs', {})
    
    for job_name, job_config in jobs.items():
        steps = job_config.get('steps', [])
        
        for i, step in enumerate(steps):
            # Check if step has continue-on-error
            if step.get('continue-on-error'):
                step_name = step.get('name', f'step-{i}')
                
                # Verify it has an id
                if 'id' not in step:
                    issues.append(
                        f"{path}: Job '{job_name}', step '{step_name}' has "
                        "continue-on-error but no id for outcome checking"
                    )
                else:
                    step_id = step['id']
                    
                    # Look for a subsequent step that checks the outcome
                    found_outcome_check = False
                    for j in range(i + 1, len(steps)):
                        next_step = steps[j]
                        if_condition = next_step.get('if', '')
                        
                        # Check if it references this step's outcome
                        if f'steps.{step_id}.outcome' in if_condition:
                            found_outcome_check = True
                            break
                    
                    if not found_outcome_check:
                        issues.append(
                            f"{path}: Job '{job_name}', step '{step_name}' (id: {step_id}) has "
                            "continue-on-error but no subsequent step checks its outcome"
                        )
    
    return issues

def main():
    """Main test function."""
    # Workflows that run on pull requests
    pr_workflows = [
        '.github/workflows/validate-prompts.yml',
        '.github/workflows/prompt-guardrails.yml',
        '.github/workflows/secrets-scan.yml',
        '.github/workflows/codeql.yml',
        '.github/workflows/dependency-review.yml',
        '.github/workflows/pr-labeler.yml',
    ]
    
    all_issues = []
    
    for workflow_path in pr_workflows:
        path = Path(workflow_path)
        if not path.exists():
            all_issues.append(f"Workflow file not found: {workflow_path}")
            continue
        
        try:
            workflow = load_workflow(path)
            
            # Check for timeouts
            all_issues.extend(check_timeouts(workflow, workflow_path))
            
            # Check continue-on-error logic
            all_issues.extend(check_continue_on_error_logic(workflow, workflow_path))
            
        except Exception as e:
            all_issues.append(f"Error processing {workflow_path}: {e}")
    
    # Report results
    if all_issues:
        print("❌ Workflow validation failed:")
        for issue in all_issues:
            print(f"  - {issue}")
        sys.exit(1)
    else:
        print("✅ All workflow validations passed:")
        print(f"  - All {len(pr_workflows)} PR workflows have timeouts configured")
        print("  - All continue-on-error steps have proper outcome checking")
        sys.exit(0)

if __name__ == '__main__':
    main()
