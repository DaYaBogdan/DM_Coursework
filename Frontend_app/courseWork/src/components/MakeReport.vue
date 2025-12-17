<template>
  <main class="make-report-component">
    <div class="info">
      <div class="fields">
        <div class="text">На кого поступает жалоба?</div>
        <div class="flexed">
          <div class="text">Логин сотрудника:</div>
          <input placeholder="Логин" type="text" v-model="formData.reported" />
        </div>
        <div class="text">Опишите, по какой причине, данный сотрудник получает жалобу</div>
        <textarea placeholder="Жалоба" v-model="formData.description" />
      </div>
      <button @click="makeReport(formData.reported, formData.description)">Отправить жалобу</button>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import router from "@/router";

const store = useStore();
const formData = {
  reported: "",
  description: "",
};

function makeReport(reported, description) {
  store.commit("sendReport", {reported, description});
  router.push("/");
}
</script>

<style lang="scss" scoped>
.flexed {
  display: flex;
  flex-direction: row;
  justify-content: center;
}

.text {
  padding: 2rem;
  padding-right: 1rem;
}

input {
  width: 20rem;
  height: 2rem;
  border-radius: 0.5rem;
  margin-top: 2rem;
  padding: 1rem;
  font-family: var(--font);

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}

textarea {
  font-size: 1rem;
  padding: 1rem;
  margin-bottom: 2rem;
  border-radius: 1rem;
}

button {
  color: var(--light);
  background-color: var(--dark);

  font-size: 2rem;
  border-radius: 0.5rem;
  width: fit-content;
  height: 3rem;
  padding-left: 2rem;
  padding-right: 2rem;
  margin: 3rem;
}
</style>
