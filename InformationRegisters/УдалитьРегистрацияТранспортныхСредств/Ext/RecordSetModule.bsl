﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = ОсновнаяОрганизация;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Количество() = 1 Тогда
		Запись = Получить(0);
		
		Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("РегистрационныйЗнак");
			МассивНепроверяемыхРеквизитов.Добавить("ИдентификационныйНомер");
			МассивНепроверяемыхРеквизитов.Добавить("Марка");
			МассивНепроверяемыхРеквизитов.Добавить("ПостановкаНаУчетВНалоговомОргане");
			МассивНепроверяемыхРеквизитов.Добавить("КодВидаТранспортногоСредства");
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяБаза");
			МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмеренияНалоговойБазы");
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяСтавка");
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяЛьгота");
			МассивНепроверяемыхРеквизитов.Добавить("ЭкологическийКласс");
			МассивНепроверяемыхРеквизитов.Добавить("ВидЗаписи");
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли