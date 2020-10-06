//
//  ObservationTests.swift
//  TriageTests
//
//  Created by Francis Li on 10/4/20.
//  Copyright © 2020 Francis Li. All rights reserved.
//

import XCTest
@testable import Peak_Response

class ObservationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExtractName() {
        let samples = [
            "Patients name is Mary Thomas",
            "Patient's name is Mary Thomas",
            "Patient name is Mary Thomas",
            "Name is Mary Thomas",
            "Name Mary Thomas",
            "First name Mary last name Thomas",
            "Last name Thomas first name Mary"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.firstName, "Mary", "firstName failed for: \(sample)")
            XCTAssertEqual(observation.lastName, "Thomas", "lastName failed for: \(sample)")
        }
    }

    func testExtractAge() {
        var samples: [String]!

        samples = [
            "age 28",
            "28 year old",
            "28 years old",
            "28-year-old",
            "28-years-old"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.age.value, 28, "age failed for: \(sample)")
            XCTAssertEqual(observation.ageUnits, PatientAgeUnits.years.rawValue, "ageUnits failed for: \(sample)")
        }

        samples = [
            "two month old",
            "two months old",
            "two-month-old",
            "two-months-old"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.age.value, 2, "age failed for: \(sample)")
            XCTAssertEqual(observation.ageUnits, PatientAgeUnits.months.rawValue, "ageUnits failed for: \(sample)")
        }
    }

    func testExtractGender() {
        var samples: [String]!

        samples = [
            "male"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.gender, PatientGender.male.rawValue)
        }

        samples = [
            "female"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.gender, PatientGender.female.rawValue)
        }

        samples = [
            "trans male",
            "transgender male"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.gender, PatientGender.transMale.rawValue)
        }

        samples = [
            "trans female",
            "transgender female"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.gender, PatientGender.transFemale.rawValue)
        }
    }

    func testExtractPriority() {
        var samples: [String]!

        samples = [
            "immediate priority",
            "priority immediate",
            "priority is immediate",
            "priority red",
            "priority is red",
            "priority read",
            "priority is read"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.priority.value, Priority.immediate.rawValue, "Priority failed for: \(sample)")
        }

        samples = [
            "delayed priority",
            "priority yellow",
            "priority is yellow",
            "priority delayed",
            "priority is delayed"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.priority.value, Priority.delayed.rawValue, "Priority failed for: \(sample)")
        }

        samples = [
            "minimal priority",
            "priority green",
            "priority is green",
            "priority minimal",
            "priority is minimal"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.priority.value, Priority.minimal.rawValue, "Priority failed for: \(sample)")
        }

        samples = [
            "priority expectant",
            "priority is expectant",
            "patient expectant",
            "patient is expectant"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.priority.value, Priority.expectant.rawValue, "Priority failed for: \(sample)")
        }

        samples = [
            "priority dead",
            "priority is dead",
            "patient dead",
            "patient is dead"
        ]
        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.priority.value, Priority.dead.rawValue, "Priority failed for: \(sample)")
        }
    }

    func testExtractBloodPressure() {
        let samples = [
            "BP 120/80",
            "BP 120 over 80",
            "BP is 120/80",
            "BP is 120 over 80",
            "blood pressure 120/80",
            "blood pressure 120 over 80",
            "blood pressure is 120/80",
            "blood pressure is 120 over 80"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.bpSystolic.value, 120, "Blood Pressure failed for: \(sample)")
            XCTAssertEqual(observation.bpDiastolic.value, 80, "Blood Pressure failed for: \(sample)")
        }
    }

    func testExtractCapillaryRefill() {
        let samples = [
            "cap refill to",
            "cap refill too",
            "cap refill two",
            "cap refill 2",
            "cap refill is to",
            "cap refill is too",
            "cap refill is two",
            "cap refill is 2",
            "cap refill time to",
            "cap refill time too",
            "cap refill time two",
            "cap refill time 2",
            "cap refill time is to",
            "cap refill time is too",
            "cap refill time is two",
            "cap refill time is 2",
            "capillary refill to",
            "capillary refill too",
            "capillary refill two",
            "capillary refill 2",
            "capillary refill is to",
            "capillary refill is too",
            "capillary refill is two",
            "capillary refill is 2",
            "capillary refill time to",
            "capillary refill time too",
            "capillary refill time two",
            "capillary refill time 2",
            "capillary refill time is to",
            "capillary refill time is too",
            "capillary refill time is two",
            "capillary refill time is 2"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.capillaryRefill.value, 2, "Capillary Refill failed for: \(sample)")
        }
    }

    func testExtractGCSTotal() {
        let samples = [
            "GCS three",
            "gcs 3",
            "glasgow coma scale 3",
            "glasgow coma scale three",
            "glasgow coma score 3",
            "glasgow coma score three"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.gcsTotal.value, 3, "GCS total failed for: \(sample)")
        }
    }

    func testExtractPulse() {
        let samples = [
            "pulse 80",
            "pulse is 80",
            "pulse rate 80",
            "pulse rate is 80",
            "heart rate 80",
            "heart rate is 80"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.pulse.value, 80, "Pulse failed for: \(sample)")
        }
    }

    func testExtractRespiratoryRate() {
        let samples = [
            "respiratory rate 20",
            "respiratory rate is 20",
            "respiration 20",
            "respiration is 20",
            "respirations 20",
            "respirations is 20"
        ]

        for sample in samples {
            let observation = Observation()
            observation.extractValues(from: sample)
            XCTAssertEqual(observation.respiratoryRate.value, 20, "Respiratory Rate failed for: \(sample)")
        }
    }
}
