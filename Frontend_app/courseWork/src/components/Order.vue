<template>
  <main class="order-component">
    <div class="display-flexed">
      <img :src="imageUrl" :alt="name" v-if="imageUrl" />
      <div class="text" id="name">{{ name }}</div>
      <div class="text" id="tags">{{ tags.join(", ") }}</div>
    </div>
  </main>
</template>

<script setup>
import {defineProps, ref, onMounted} from "vue";

const props = defineProps({
  image: String,
  name: String,
  tags: Array,
});

const imageUrl = ref(null);

onMounted(async () => {
  if (props.image) {
    console.log(props.image);
    imageUrl.value = `http://localhost:8000/api/get_image/${props.image}`;
  }
});
</script>

<style lang="scss" scoped>
img {
  width: 10rem;
  height: 14rem;
  margin: 0rem;
  border-radius: 1rem;
}

.display-flexed {
  align-content: center;
  justify-content: center;
  text-align: center;
}

.bottom {
  justify-self: flex-end;
  margin-bottom: 2rem;
}

.text {
  font-size: 1.2rem;
  padding: 0.5rem;
}
</style>
