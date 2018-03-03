﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	Если Параметры.Свойство("ВозвратЗначенияБезЗаписи") Тогда
		ВозвратЗначенияБезЗаписи = Параметры.ВозвратЗначенияБезЗаписи;
	КонецЕсли;
	
	ЗаполнитьДоступныеСчета();
	Элементы.ФормаЗаписать.Видимость = Не ВозвратЗначенияБезЗаписи;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ВозвратЗначенияБезЗаписи Тогда
		
		Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
			Текст = НСтр("ru = 'Поле ""Организация"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, Параметры.Ключ, "Запись.Организация", "Запись.Организация", Отказ);
			Возврат;
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		Отказ = Истина;
		Модифицированность = Ложь;
		СтруктураВозврата = Новый Структура("Организация, ВидСертификата, СчетУчета");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Запись);
		Закрыть(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ЗаполнитьДоступныеСчета()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	
	// Счета учета в эксплуатации
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоАвансаПолученным)));
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
