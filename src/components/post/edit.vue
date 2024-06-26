<script setup lang="ts">
const emit = defineEmits(['click:confirm', 'click:preview'])
const { prefectureItems, makerItems } = await useFetchMaster()
import type { FileUpload, ListDialog, Recaptcha } from '#build/components'
import { useRecaptchaProvider } from 'vue-recaptcha'
import { useGoTo } from 'vuetify'
import type { VForm } from 'vuetify/components'

useRecaptchaProvider()

const goTo = useGoTo()

const formRef = ref<InstanceType<typeof VForm> | null>(null)
const makerRef = ref<InstanceType<typeof ListDialog> | null>(null)
const uploadRef = ref<InstanceType<typeof FileUpload> | null>(null)
const recaptchaRef = ref<InstanceType<typeof Recaptcha> | null>(null)

const formData = defineModel<PostEdit>('formData', { required: true })

/**
 * この内容で掲載依頼する押下
 */
const onConfirm = async () => {
  if (!(await validate())) {
    goTo(`.v-messages__message.v-messages`)
    return
  }

  if (!recaptchaRef.value?.validate()) {
    goTo(`.v-messages__message.v-messages`)
    return
  }

  emit('click:confirm', formData.value)
}

/**
 * プレビュー押下
 */
const onClickPreview = async () => {
  if (!(await validate())) {
    goTo(`.v-messages__message.v-messages`)
    return
  }

  formData.value.recaptcha = undefined
  emit('click:preview', formData.value)
}

/**
 * バリデーション
 */
const validate = async () => {
  const validate = await formRef.value?.validate()
  const makerResult = await makerRef.value?.validate()
  const uploadResult = await uploadRef.value?.validate()

  return validate?.valid && makerResult && uploadResult
}
</script>

<template>
  <div>
    <div>掲載依頼する</div>

    <v-form ref="formRef" class="tw-w-full tw-max-w-3xl">
      <TextField
        v-model:text="formData.carName"
        label="車種名"
        placeholder="プリウス"
        :counter="30"
        :rules="[validationUtil.required]"
        required
        clearable
        type="text"
      ></TextField>

      <ListDialog
        ref="makerRef"
        v-model:current-items="formData.makers"
        title="メーカー選択"
        label="メーカー・車名"
        button-name="メーカー・車名"
        :items="makerItems"
        chip-label="必須"
        :rules="[validationUtil.required]"
      ></ListDialog>

      <FileUpload
        ref="uploadRef"
        v-model:current-items="formData.files"
        :rules="[validationUtil.requiredFile, validationUtil.maxFileSize]"
      ></FileUpload>

      <TextArea
        v-model:text="formData.description"
        label="商品説明"
        placeholder="商品説明"
        hint="1000文字以内で入力してください"
        :counter="1000"
        required
        clearable
        :rules="[validationUtil.required]"
      ></TextArea>

      <TextField
        v-model:text="formData.price"
        label="価格"
        placeholder="500,000"
        required
        clearable
        type="number"
        :rules="[
          validationUtil.required,
          (v) => validationUtil.max(+v, 10000000, '円以内にしてください'),
        ]"
      ></TextField>

      <TextField
        v-model:text="formData.userName"
        label="ユーザー名"
        placeholder="オルカー"
        required
        clearable
        type="text"
        :counter="30"
        :rules="[validationUtil.required]"
      ></TextField>

      <TextField
        v-model:text="formData.link"
        label="掲載ページのリンク"
        placeholder="https://example.com"
        required
        clearable
        type="text"
        :counter="1000"
        :rules="[validationUtil.required, validationUtil.url]"
      ></TextField>

      <TextField
        v-model:text="formData.email"
        label="メールアドレス"
        placeholder="support@ol-car.com"
        required
        clearable
        type="text"
        :counter="256"
        :rules="[validationUtil.required, validationUtil.email]"
      ></TextField>

      <TextField
        v-model:text="formData.mileage"
        label="走行距離"
        placeholder="50,000"
        clearable
        type="number"
        :rules="[(v) => validationUtil.max(+v, 500000, 'km以内にしてください')]"
      ></TextField>

      <FromTo
        v-model:from="formData.vehicleInspection.year"
        v-model:to="formData.vehicleInspection.month"
        label="車検満了"
        :from-item="Constants.YEAR"
        :to-item="Constants.MONTH"
        is-from-label=""
      ></FromTo>

      <ListDialog
        :current-items="formData.prefectures"
        title="都道府県選択"
        label="都道府県"
        button-name="都道府県"
        :items="prefectureItems"
      ></ListDialog>

      <TextField
        v-model:text="formData.locality"
        label="市区町村"
        placeholder="横浜市"
        required
        clearable
        type="text"
        :counter="30"
      ></TextField>

      <Recaptcha ref="recaptchaRef" v-model:recaptcha="formData.recaptcha"></Recaptcha>
      <v-btn @click="onClickPreview">プレビュー</v-btn>
      <v-btn @click="onConfirm">この内容で掲載依頼する</v-btn>
    </v-form>
  </div>
</template>
