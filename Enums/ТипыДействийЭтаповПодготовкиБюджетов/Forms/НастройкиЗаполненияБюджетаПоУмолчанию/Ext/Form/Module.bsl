﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидБюджета = Параметры.ВидБюджета;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	АдресАналитикаЗаполненияБюджета = Параметры.АдресАналитикаЗаполненияБюджета;
	КлючСтроки = Параметры.КлючСтроки;
	
	АналитикаЗаполненияБюджета.Загрузить(ПолучитьИзВременногоХранилища(АдресАналитикаЗаполненияБюджета));
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	РеквизитыБюджета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "АналитикиШапки").Выгрузить();
	Для Сч = 1 По РеквизитыБюджета.Количество() Цикл
		Элементы["АналитикаЗаполненияБюджетаАналитика" + Сч].Заголовок = Строка(РеквизитыБюджета[Сч - 1].ВидАналитики);
		Элементы["АналитикаЗаполненияБюджетаАналитика" + Сч].ОграничениеТипа = РеквизитыБюджета[Сч - 1].ВидАналитики.ТипЗначения;
	КонецЦикла;
	
	КоличествоАналитик = РеквизитыБюджета.Количество();
	Если КоличествоАналитик < 6 Тогда
		Для Сч = КоличествоАналитик + 1 по 6 Цикл
			Элементы["АналитикаЗаполненияБюджетаГруппаАналитика" + Сч].Видимость = Ложь;
			Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
				Стр["Аналитика" + Сч] = Неопределено;
				Стр["ДоступностьАналитика" + Сч] = Ложь;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыФО = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	ФормироватьБюджетыПоОрганизациям = ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоОрганизациям", ПараметрыФО);
	ФормироватьБюджетыПоПодразделениям = ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоПодразделениям", ПараметрыФО);
	
	Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
		Если Не ФормироватьБюджетыПоОрганизациям Тогда
			Стр.Организация = Неопределено;
			Стр.ДоступностьОрганизация = Ложь;
			Элементы.АналитикаЗаполненияБюджетаГруппаОрганизация.Видимость = Ложь;
		КонецЕсли;
		
		Если Не ФормироватьБюджетыПоПодразделениям Тогда
			Стр.Подразделение = Неопределено;
			Стр.ДоступностьПодразделение = Ложь;
			Элементы.АналитикаЗаполненияБюджетаГруппаПодразделение.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.АналитикаЗаполненияБюджета.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСтроки", КлючСтроки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АналитикаЗаполненияБюджетаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.АналитикаЗаполненияБюджета.ТекущиеДанные.КлючСтроки = КлючСтроки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Отказ = Ложь; 
	ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
	Если Не Отказ Тогда 
		Результат = Новый Структура("Адрес,КлючСтрокиНастройкиАналитики", СохранитьНастройкиНаСервере(), КлючСтроки );
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(АналитикаЗаполненияБюджета.Выгрузить(), Адрес);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Сч = 0;
	Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
		
		Если Стр.КлючСтроки = КлючСтроки Тогда 		
			Если Не ЗначениеЗаполнено(Стр.Сценарий) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не заполнен сценарий'"),Сч+1),,,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("АналитикаЗаполненияБюджета[%1].Сценарий", Сч),Отказ);
			Конецесли;
			
			Если ФормироватьБюджетыПоОрганизациям И Не ЗначениеЗаполнено(Стр.Организация) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не заполнена организация'"),Сч+1),,,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("АналитикаЗаполненияБюджета[%1].Организация", Сч),Отказ);
			Конецесли;
			
			Если ФормироватьБюджетыПоПодразделениям И Не ЗначениеЗаполнено(Стр.Подразделение) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не заполнено подразделение'"),Сч+1),,,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("АналитикаЗаполненияБюджета[%1].Подразделение", Сч),Отказ);
			Конецесли;
			Сч = Сч + 1;	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьВозможностьИзмененияАналитики(Команда)
	
	ТекущиеДанные = Элементы.АналитикаЗаполненияБюджета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяЯчейка = Элементы.АналитикаЗаполненияБюджета.ТекущийЭлемент;
	Если ТекущаяЯчейка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаДоступности = "Доступность" + СтрЗаменить(ТекущаяЯчейка.Имя, "АналитикаЗаполненияБюджета", "");
	ТекущиеДанные[ИмяРеквизитаДоступности] = Не ТекущиеДанные[ИмяРеквизитаДоступности];
	
КонецПроцедуры

#КонецОбласти