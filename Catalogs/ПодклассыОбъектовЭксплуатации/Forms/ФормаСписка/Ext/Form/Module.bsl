﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Владелец = Параметры.Отбор.Владелец;
		
		ИспользуютсяПодклассы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ИспользуютсяПодклассы");
		
		Если Не ЗначениеЗаполнено(ИспользуютсяПодклассы) Или Не ИспользуютсяПодклассы Тогда
			
			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" использование подклассов не определено'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));
			
			АвтоЗаголовок = Ложь;
			Заголовок = ТекстЗаголовка;
			
			Элементы.Список.ТолькоПросмотр = Истина;
			
		Иначе
			
			ТекстЗаголовка = НСтр("ru = 'Подклассы объектов ремонта (%Владелец%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));
			
			АвтоЗаголовок = Ложь;
			Заголовок = ТекстЗаголовка;
			
		КонецЕсли;
		
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

