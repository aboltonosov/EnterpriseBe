﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Для Каждого СтрокаТЧ Из ШаблоныКодовПодарочныхСертификатов Цикл
		
		Если ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
			СтрокаТЧ.ДлинаШтрихкода = 0;
			СтрокаТЧ.НачалоДиапазонаШтрихкода = "";
			СтрокаТЧ.КонецДиапазонаШтрихкода = "";
		КонецЕсли;
		
		Если ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
			СтрокаТЧ.ДлинаМагнитногоКода = 0;
			СтрокаТЧ.НачалоДиапазонаМагнитногоКода = "";
			СтрокаТЧ.КонецДиапазонаМагнитногоКода = "";
			СтрокаТЧ.ШаблонМагнитнойКарты = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаТЧ Из ШаблоныКодовПодарочныхСертификатов Цикл
		
		Если ТипКарты = Перечисления.ТипыКарт.Магнитная
			ИЛИ ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ДлинаМагнитногоКода) Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтрДлина(СтрокаТЧ.НачалоДиапазонаМагнитногоКода) > СтрокаТЧ.ДлинаМагнитногоКода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" количество символов нижней границы диапазона магнитного кода превышает длину магнитного кода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаМагнитногоКода"),
					,
					Отказ);
			КонецЕсли;
			
			Если СтрДлина(СтрокаТЧ.КонецДиапазонаМагнитногоКода) > СтрокаТЧ.ДлинаМагнитногоКода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" количество символов верхней границы диапазона магнитного кода превышает длину магнитного кода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "КонецДиапазонаМагнитногоКода"),
					,
					Отказ);
			КонецЕсли;
			
			Если СтрокаТЧ.КонецДиапазонаМагнитногоКода < СтрокаТЧ.НачалоДиапазонаМагнитногоКода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" нижняя граница диапазона магнитного кода превышает верхнюю границу дипазона магнитного кода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаШтрихкода"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТипКарты = Перечисления.ТипыКарт.Штриховая
			ИЛИ ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ДлинаШтрихкода) Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтрДлина(СтрокаТЧ.НачалоДиапазонаШтрихкода) > СтрокаТЧ.ДлинаШтрихкода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" количество символов нижней границы диапазона штрихкода превышает длину штрихкода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаШтрихкода"),
					,
					Отказ);
			КонецЕсли;
			
			Если СтрДлина(СтрокаТЧ.КонецДиапазонаШтрихкода) > СтрокаТЧ.ДлинаШтрихкода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" количество символов верхней границы диапазона штрихкода превышает длину штрихкода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "КонецДиапазонаШтрихкода"),
					,
					Отказ);
			КонецЕсли;
			
			Если СтрокаТЧ.КонецДиапазонаШтрихкода < СтрокаТЧ.НачалоДиапазонаШтрихкода Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке %1 списка ""Шаблоны кодов карт лояльности"" нижняя граница диапазона штрихкода превышает верхнюю границу дипазона штрихкода.'"), СтрокаТЧ.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ШаблоныКодовПодарочныхСертификатов", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаШтрихкода"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.ДлинаШтрихкода");
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.НачалоДиапазонаШтрихкода");
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.КонецДиапазонаШтрихкода");
	КонецЕсли;
	Если ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.ДлинаМагнитногоКода");
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.НачалоДиапазонаМагнитногоКода");
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.КонецДиапазонаМагнитногоКода");
		МассивНепроверяемыхРеквизитов.Добавить("ШаблоныКодовПодарочныхСертификатов.ШаблонМагнитнойКарты");
	КонецЕсли;
	
	КонтролироватьЗаполнениеАналитики = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	Если КонтролироватьЗаполнениеАналитики = Истина Тогда
		ПроверяемыеРеквизиты.Добавить("АналитикаДоходов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		ВидыСчетаДляОчистки = Новый Массив;
		Если ЗначениеЗаполнено(СчетУчета) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам);
		КонецЕсли;
		Если ВидыСчетаДляОчистки.Количество() Тогда
			РегистрыСведений.СчетаРеглУчетаТребующиеНастройки.ОчиститьПриЗаписиАналитикиУчета(Ссылка, ВидыСчетаДляОчистки);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
