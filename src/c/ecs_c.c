#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>

#include <assert.h>
#include <time.h>

#define TOMBSTONE_ID (-1)

typedef unsigned uint;

enum {
	// ca_init
	success_CA_INIT,
	error_CA_INIT__ALLOC_FAILURE,
	// ca_register_id
	success_CA_REGISTER_ID,
	error_CA_REGISTER_ID__ID_OOB,
	error_CA_REGISTER_ID__DUPLICATE_ID_FOUND,
	// ca_remove_id
	success_CA_REMOVE_ID,
	error_CA_REMOVE_ID__ID_OOB,
	error_CA_REMOVE_ID__ID_NOT_FOUND,
	// ca_component_set
	success_CA_COMPONENT_SET,
	error_CA_COMPONENT_SET__ID_OOB,
	error_CA_COMPONENT_SET__ID_NOT_FOUND,
	// ca_component_get
	success_CA_COMPONENT_GET,
	error_CA_COMPONENT_GET__ID_OOB,
	error_CA_COMPONENT_GET__ID_NOT_FOUND,
};

// Basic example component of one type
struct component {
	uint x;
	uint y;
	uint z;
};

// Components are kept by 3 arrays:
// sparse_array: maps an entity ID to a component location in packed_array
// id_array: parallel array with packed_array for component -> ID lookup
// packed_array: packed array of components that is always contiguous
struct component_array {
	int registered;
	size_t array_size;

	int *sparse_array;
	int *id_array;
	struct component *packed_array;
};

// Initialize and allocate all internal memory
int ca_init(struct component_array *comp_array, struct component *packed_array, size_t array_size) {
	assert(comp_array != NULL);
	assert(packed_array != NULL);
	assert(array_size > 0);

	// Allocate all internal arrays
	comp_array->sparse_array = malloc(array_size * sizeof (*comp_array->sparse_array));
	if (comp_array->sparse_array == NULL)
		return error_CA_INIT__ALLOC_FAILURE;

	comp_array->id_array = malloc(array_size * sizeof (*comp_array->id_array));
	if (comp_array->id_array == NULL) {
		free(comp_array->sparse_array);
		return error_CA_INIT__ALLOC_FAILURE;
	}

	// Initialize sparse array to tombstone value
	for (int i = 0; i < array_size; i++)
		comp_array->sparse_array[i] = TOMBSTONE_ID;

	comp_array->packed_array = packed_array;

	comp_array->registered = 0;
	comp_array->array_size = array_size;

	return success_CA_INIT;
}

int ca_register_id(struct component_array *comp_array, uint id, struct component init_val) {
	assert(comp_array != NULL);

	// Check bounds to prevent overflow
	if (id >= comp_array->array_size)
		return error_CA_REGISTER_ID__ID_OOB;

	// Check if this ID is already registered
	if (comp_array->sparse_array[id] != TOMBSTONE_ID)
		return error_CA_REGISTER_ID__DUPLICATE_ID_FOUND;

	// registered == the current end of packed and id arrays
	comp_array->sparse_array[id] = comp_array->registered;
	comp_array->id_array[comp_array->registered] = id;
	comp_array->packed_array[comp_array->registered] = init_val;
	
	comp_array->registered += 1;
	return success_CA_REGISTER_ID;
}

int ca_component_set(struct component_array *comp_array, uint id, struct component new_val) {
	assert(comp_array != NULL);

	// Check bounds to prevent overflow
	if (id >= comp_array->array_size)
		return error_CA_COMPONENT_SET__ID_OOB;

	// Check if this ID is already registered
	if (comp_array->sparse_array[id] == TOMBSTONE_ID)
		return error_CA_COMPONENT_SET__ID_NOT_FOUND;

	int packed_index = comp_array->sparse_array[id];
	comp_array->packed_array[packed_index] = new_val;

	return success_CA_COMPONENT_SET;
}

// Basic entity is nothing but an ID
struct entity {
	int id;
};

struct process {
	void (*operation)(struct component *, struct component *, uint *results, size_t size, int random_int);
	struct component_array *inputs[2];
	uint *results;
};

static inline void process_run(struct process *process, int random_int) {
	process->operation(process->inputs[0]->packed_array, process->inputs[1]->packed_array, process->results, process->inputs[0]->registered, random_int);
}

// Do a bunch of random math between the input variables and save to results
void batch_operation(
		struct component *restrict comp_1, 
		struct component *restrict comp_2, 
        uint *restrict results, 
		size_t size,
		int random_int
) {

	for (int i = 0; i < size; i++) {
		int x1 = comp_1[i].x, y1 = comp_1[i].y, z1 = comp_1[i].z;
		int x2 = comp_2[i].x, y2 = comp_2[i].y, z2 = comp_2[i].z;

		uint result = (x1 + x2) + (x1 + y2) + (x1 + z2);
		result += y1 + x2;
		result -= z2;
		result += z2 * z1;
		results[i] = result / random_int;
	}
}

#define NUM_ENTITIES (1000000)
int main() {
	// Seed PRNG
	srand(time(NULL));

	// Allocate an array of entities
	struct entity *entities = malloc(NUM_ENTITIES * sizeof (*entities));
	for (int i = 0; i < NUM_ENTITIES; i++)
		entities[i].id = NUM_ENTITIES - i - 1;

	// Allocate all arrays that will be operated on at the same time
	// This is what could be called an "archetype" in an ECS
	struct component *comps_1 = malloc(NUM_ENTITIES * (sizeof *comps_1));
	if (comps_1 == NULL)
		return 1;
	struct component *comps_2 = malloc(NUM_ENTITIES * (sizeof *comps_2));
	if (comps_2 == NULL)
		return 1;
	uint *results = malloc(NUM_ENTITIES * (sizeof *results));
	if (results == NULL)
		return 1;


	// Give our component arrays to their wrapper objects for management
	struct component_array comp_array_1;
	if (ca_init(&comp_array_1, comps_1, NUM_ENTITIES) != success_CA_INIT)
		return 1;

	struct component_array comp_array_2;
	if (ca_init(&comp_array_2, comps_2, NUM_ENTITIES) != success_CA_INIT)
		return 1;

	// Register all entities with both component_arrays
	// Initial component value
	struct component temp_comp = {0, 0, 0};
	for (int i = 0; i < NUM_ENTITIES; i++) {
		ca_register_id(&comp_array_1, entities[i].id, temp_comp);
		ca_register_id(&comp_array_2, entities[i].id, temp_comp);
	}

	int rand_mod = 100;
	// Fill all components with random values from 1 - rand_mod 
	// We wind up with two completely random sets of entities
	for (int i = 0; i < NUM_ENTITIES; i++) {
		temp_comp.x = (rand() % rand_mod) + 1;
		temp_comp.y = (rand() % rand_mod) + 1;
		temp_comp.z = (rand() % rand_mod) + 1;
		ca_component_set(&comp_array_1, entities[i].id, temp_comp);

		temp_comp.x = (rand() % rand_mod) + 1;
		temp_comp.y = (rand() % rand_mod) + 2;
		temp_comp.z = (rand() % rand_mod) + 1;
		ca_component_set(&comp_array_2, entities[i].id, temp_comp);
	}

	struct process math_process = {
		.operation = batch_operation,
		.results = results
	};

	math_process.inputs[0] = &comp_array_1;
	math_process.inputs[1] = &comp_array_2;

	clock_t start, end;
	double cpu_time;

	start = clock();

#define PROCESS_ITERATIONS (10000)
	for (int i = 0; i < PROCESS_ITERATIONS; i++)
		process_run(&math_process, (rand() %3) + 1);

	end = clock();

	cpu_time = ((double)(end - start)) / CLOCKS_PER_SEC;

	printf("              entities: %u\n", NUM_ENTITIES);
	printf("            iterations: %u\n", PROCESS_ITERATIONS);
	printf("    total process time: %.2f s\n", cpu_time);
	printf("average iteration time: %05.2f ms\n", (cpu_time * 1000) / PROCESS_ITERATIONS);

	return 0;
}
