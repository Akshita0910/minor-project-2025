class GeneticAlgorithmScheduler {
    constructor(courses, instructors, rooms, timeslots, populationSize, generations) {
        this.courses = courses;
        this.instructors = instructors;
        this.rooms = rooms;
        this.timeslots = timeslots;
        this.populationSize = populationSize;
        this.generations = generations;
    }

    generateIndividual() {
        const individual = {};
        for (const course of this.courses) {
            individual[course] = {
                instructor: this.instructors[Math.floor(Math.random() * this.instructors.length)],
                room: this.rooms[Math.floor(Math.random() * this.rooms.length)],
                timeslot: this.timeslots[Math.floor(Math.random() * this.timeslots.length)]
            };
        }
        return individual;
    }

    fitness(individual) {
        let score = 0;
        const assigned = {};

        for (const course in individual) {
            const { instructor, room, timeslot } = individual[course];

            // Check for conflicts
            const conflictKey = `${room}-${timeslot}`;
            if (assigned[conflictKey]) {
                score -= 1; // Penalty for room-time conflict
            } else {
                assigned[conflictKey] = true;
                score += 1; // Reward for valid assignment
            }
        }

        return score;
    }

    crossover(parent1, parent2) {
        const child = {};
        for (const course in parent1) {
            child[course] = Math.random() < 0.5 ? parent1[course] : parent2[course];
        }
        return child;
    }

    mutate(individual) {
        const randomCourse = Object.keys(individual)[Math.floor(Math.random() * Object.keys(individual).length)];
        individual[randomCourse].timeslot = this.timeslots[Math.floor(Math.random() * this.timeslots.length)];
    }

    run() {
        let population = Array.from({ length: this.populationSize }, () => this.generateIndividual());

        for (let generation = 0; generation < this.generations; generation++) {
            // Calculate fitness for the population
            const fitnessScores = population.map(individual => ({
                individual,
                fitness: this.fitness(individual)
            }));

            // Sort by fitness (highest first)
            fitnessScores.sort((a, b) => b.fitness - a.fitness);

            // Select top individuals for mating
            const matingPool = fitnessScores.slice(0, Math.floor(this.populationSize / 2));

            // Generate next generation
            const newPopulation = [];
            while (newPopulation.length < this.populationSize) {
                const parent1 = matingPool[Math.floor(Math.random() * matingPool.length)].individual;
                const parent2 = matingPool[Math.floor(Math.random() * matingPool.length)].individual;
                const child = this.crossover(parent1, parent2);
                if (Math.random() < 0.1) this.mutate(child); // Apply mutation
                newPopulation.push(child);
            }

            population = newPopulation;
        }

        // Return the best individual from the final population
        return population.sort((a, b) => this.fitness(b) - this.fitness(a))[0];
    }
}

// Example Usage
const courses = ["Data Structures", "Algorithms", "Operating Systems", "Database Systems"];
const instructors = ["Dr. A", "Dr. B", "Dr. C", "Dr. D"];
const rooms = ["Room 101", "Room 102"];
const timeslots = ["9:00-10:00", "10:00-11:00", "11:00-12:00"];

const gaScheduler = new GeneticAlgorithmScheduler(courses, instructors, rooms, timeslots, 100, 50);
const bestSchedule = gaScheduler.run();
console.log("Best Schedule:", bestSchedule);