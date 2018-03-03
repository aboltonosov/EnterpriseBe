﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидыУчетов") Тогда
		ВидыУчетов = Параметры.ВидыУчетов;
		
		Если ВидыУчетов = "ДанныеДляРасчетаСреднего" Тогда
			Объект.УчетСреднегоЗаработка = Истина;
			Элементы.ГруппаВидыУчета.Видимость = Ложь;
			Заголовок = НСтр("ru = 'Обновить данные для расчета среднего заработка'");
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыРасширенная") Тогда
		Объект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УчетСреднегоЗаработкаПриИзменении(Элемент)
	
	Если Объект.УчетСреднегоЗаработка Тогда
		ВидыУчетов = "ДанныеДляРасчетаСреднего";
	Иначе
		ВидыУчетов = Неопределено;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ПровестиДокументы(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Период) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен период'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидыУчетов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнены виды учетов'"));
		Возврат;
	КонецЕсли;
			
	Результат = ПровестиДокументыНаСервере();
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
						
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПровестиДокументыНаСервере()
	
	ВидыУчета = ?(Объект.УчетСреднегоЗаработка, "ДанныеДляРасчетаСреднего", Неопределено);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидыУчета", ВидыУчета);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Период", Объект.Период);
		
	НаименованиеЗадания = НСтр("ru = 'Обновление данных для расчета среднего заработка'");
		
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ПроведениеДокументовПоВидамУчета.ПровестиДокументыПоУчетам",
		СтруктураПараметров,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Возврат Результат;
				
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

#КонецОбласти



