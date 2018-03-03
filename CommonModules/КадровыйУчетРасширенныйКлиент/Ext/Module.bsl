﻿////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетРасширенныйКлиент: методы кадрового учета, работающие на стороне клиента.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. процедуру КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДату.
//
Процедура ВыбратьСотрудниковРаботающихНаДату(ВладелецФормыВыбора, Организация = Неопределено, Подразделение = Неопределено, ДатаПримененияОтбора = '00010101', МножественныйВыбор = Истина, АдресСпискаПодобранныхСотрудников = "", СтруктураОтбора = Неопределено) Экспорт
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДату(ВладелецФормыВыбора, Организация, Подразделение, ДатаПримененияОтбора, МножественныйВыбор, АдресСпискаПодобранныхСотрудников, СтруктураОтбора);
	
КонецПроцедуры

// См. процедуру КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде.
//
Процедура ВыбратьСотрудниковРаботающихВПериоде(ВладелецФормыВыбора, Организация = Неопределено, Подразделение = Неопределено, НачалоПериодаПримененияОтбора = '00010101', ОкончаниеПериодаПримененияОтбора = '00010101', МножественныйВыбор = Истина, АдресСпискаПодобранныхСотрудников = "", СтруктураОтбора = Неопределено) Экспорт
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде(ВладелецФормыВыбора, Организация, Подразделение, НачалоПериодаПримененияОтбора, ОкончаниеПериодаПримененияОтбора, МножественныйВыбор, АдресСпискаПодобранныхСотрудников, СтруктураОтбора);
	
КонецПроцедуры

// Открывает форму редактирования стажей сотрудника.
//
// Параметры:
//		Форма			- УправляемаяФорма
//		Сотрудник		- СправочникСсылка.Сотрудники
//		ДатаСведений	- Дата
//		ВидыСтажа		- Массив ссылок на элементы справочника ВидыСтажа.
//		ФизическоеЛицо	- СправочникСсылка.ФизическиеЛица, передается если известно.
//		ДанныеСтажей	- Соответствие - Данные стажей сотрудника.
//   						* Ключ - Вид стажа;
//   						* Значение - Структура, сформированная методом ЗарплатаКадрыРасширенныйКлиентСервер.СведенияОСтаже().
//		Записывать 		- Булево - Если Истина, данные о стаже будут записаны при закрытии формы.
//		НеобязательныеВидыСтажа	- Фиксированное соответствие - стажи, заполнение которых необязательно. Для этих стажей будет
//                                                             выведен флажок, разрешающий редактирование данных стажа. Эти
//                                                             виды стажа должны также быть перечислены в параметре ВидыСтажа.
//   						* Ключ - Вид стажа;
//   						* Значение - Строка, заголовок флажка.
//
Процедура ОткрытьФормуРедактированияСтажейСотрудника(Форма, Сотрудник, ДатаСведений, ВидыСтажа, ФизическоеЛицо = Неопределено, ДанныеСтажей = Неопределено, Записывать = Истина, НеобязательныеВидыСтажа = Неопределено) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	ПараметрыОткрытия.Вставить("Сотрудник", Сотрудник);
	ПараметрыОткрытия.Вставить("ДатаСведений", ДатаСведений);
	ПараметрыОткрытия.Вставить("ВидыСтажа", ВидыСтажа);
	ПараметрыОткрытия.Вставить("ДанныеСтажей", ДанныеСтажей);
	ПараметрыОткрытия.Вставить("Записывать", Записывать);
	ПараметрыОткрытия.Вставить("НеобязательныеВидыСтажа", НеобязательныеВидыСтажа);
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ПараметрыОткрытия.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	КонецЕсли; 
	
	ОткрытьФорму("ОбщаяФорма.ВводСтажаСотрудников", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму редактирования стажей физического лица.
//
// Параметры:
//		Форма			- УправляемаяФорма
//		ФизическоеЛицо		- СправочникСсылка.ФизическиеЛица
//		ДатаСведений	- Дата
//		ВидыСтажа		- Массив ссылок на элементы справочника ВидыСтажа.
//		ДанныеСтажей	- Соответствие - Данные стажей сотрудника.
//   						* Ключ - Вид стажа;
//   						* Значение - Структура, сформированная методом ЗарплатаКадрыРасширенныйКлиентСервер.СведенияОСтаже().
//		ЗаголовокФормы	- Строка, произвольный заголовок формы ввода стажей
//
Процедура ОткрытьФормуРедактированияСтажейФизическогоЛица(Форма, ФизическоеЛицо, ДатаСведений, ВидыСтажа, ДанныеСтажей, ЗаголовокФормы = "") Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	ПараметрыОткрытия.Вставить("ДатаСведений", ДатаСведений);
	ПараметрыОткрытия.Вставить("ВидыСтажа", ВидыСтажа);
	ПараметрыОткрытия.Вставить("ДанныеСтажей", ДанныеСтажей);
	ПараметрыОткрытия.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	
	ОткрытьФорму("ОбщаяФорма.ВводСтажаСотрудников", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

Процедура ИзменитьКоличествоСтавок(Форма, ПутьКРеквизитуКоличествоСтавок, СтандартнаяОбработка, ПутьКРеквизитуПредставленияКоличестваСтавок = "", ОповещениеЗавершения = Неопределено, КоллекцияСКоличествомСтавок = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПутьКРеквизитуКоличествоСтавок", ПутьКРеквизитуКоличествоСтавок);
	
	Если ЗначениеЗаполнено(ПутьКРеквизитуПредставленияКоличестваСтавок) Тогда
		ДополнительныеПараметры.Вставить("ПутьКРеквизитуПредставленияКоличестваСтавок", ПутьКРеквизитуПредставленияКоличестваСтавок);
	КонецЕсли; 
	
	Если ОповещениеЗавершения <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	КонецЕсли; 
	
	Если КоллекцияСКоличествомСтавок = Неопределено Тогда
		ДополнительныеПараметры.Вставить("КоллекцияСКоличествомСтавок", Форма);
	Иначе
		ДополнительныеПараметры.Вставить("КоллекцияСКоличествомСтавок", КоллекцияСКоличествомСтавок);
	КонецЕсли;
	
	КоличествоСтавок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		ДополнительныеПараметры.КоллекцияСКоличествомСтавок, ПутьКРеквизитуКоличествоСтавок);
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("КоличествоСтавок", КоличествоСтавок);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр );
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьКоличествоСтавокЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ВводКоличестваСтавок", ПараметрыОткрытия, Форма, Истина, , , Оповещение);
	
КонецПроцедуры

Процедура ИзменитьКоличествоСтавокЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
			ДополнительныеПараметры.КоллекцияСКоличествомСтавок, ДополнительныеПараметры.ПутьКРеквизитуКоличествоСтавок, Результат);
			
		Если ДополнительныеПараметры.Свойство("ПутьКРеквизитуПредставленияКоличестваСтавок") Тогда
				
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				ДополнительныеПараметры.КоллекцияСКоличествомСтавок,
				ДополнительныеПараметры.ПутьКРеквизитуПредставленияКоличестваСтавок,
				КадровыйУчетРасширенныйКлиентСервер.ПредставлениеКоличестваСтавок(Результат));
				
		КонецЕсли; 
			
		Если ДополнительныеПараметры.Свойство("ОповещениеЗавершения") Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, Результат);
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписьюКадровогоДокументаВФорме(Форма, Объект, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт 
	
	Перем РезультатыПроверки;
	
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	
	ИспользуетсяШтатноеРасписание = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание");
	Если ИспользуетсяШтатноеРасписание
		И Форма.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ДанныеОЗанятыхПозициях = Форма.ПолучитьДанныеОЗанятыхПозициях();
		Если НЕ Форма.ПроверкаПередЗаписьюНаСервере(РезультатыПроверки, ДанныеОЗанятыхПозициях) Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ДанныеОЗанятыхПозициях", ДанныеОЗанятыхПозициях);
			ПараметрыФормы.Вставить("ПроверкаПередЗаписью", Истина);
			ПараметрыФормы.Вставить("ПроверяемыйРегистратор", Объект.Ссылка);
			ПараметрыФормы.Вставить("РезультатыПроверки", РезультатыПроверки);
			
			Оповещение = Новый ОписаниеОповещения("ПередЗаписьюКадровогоДокументаВФормеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("ОбщаяФорма.ПроверкаСоответствияШтатномуРасписанию", ПараметрыФормы, Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе 
			
			СтруктураПроверки = Новый Структура("ВыбранноеДействие", Истина);
			ПередЗаписьюКадровогоДокументаВФормеЗавершение(СтруктураПроверки, ДополнительныеПараметры);
			
		КонецЕсли;
		
	ИначеЕсли Не ИспользуетсяШтатноеРасписание 
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		
		ДанныеОЗанятыхПозициях = Форма.ПолучитьДанныеОЗанятыхПозициях();
		Если НЕ Форма.ПроверкаПередЗаписьюНаСервере(РезультатыПроверки, ДанныеОЗанятыхПозициях) Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ДанныеОЗанятыхПозициях", ДанныеОЗанятыхПозициях);
			ПараметрыФормы.Вставить("ПроверкаПередЗаписью", Истина);
			ПараметрыФормы.Вставить("ПроверяемыйРегистратор", Объект.Ссылка);
			ПараметрыФормы.Вставить("РезультатыПроверки", РезультатыПроверки);
			ПараметрыФормы.Вставить("ПроверкаСоответствияГрейдам", Истина);
			
			Оповещение = Новый ОписаниеОповещения("ПередЗаписьюКадровогоДокументаВФормеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("ОбщаяФорма.ПроверкаСоответствияШтатномуРасписанию", ПараметрыФормы, Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе 
			
			СтруктураПроверки = Новый Структура("ВыбранноеДействие", Истина);
			ПередЗаписьюКадровогоДокументаВФормеЗавершение(СтруктураПроверки, ДополнительныеПараметры);
			
		КонецЕсли;
		
	Иначе 
		
		СтруктураПроверки = Новый Структура("ВыбранноеДействие", Истина);
		ПередЗаписьюКадровогоДокументаВФормеЗавершение(СтруктураПроверки, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписьюКадровогоДокументаВФормеЗавершение(СтруктураПроверки, ДополнительныеПараметры) Экспорт 

	Если СтруктураПроверки = Неопределено Или СтруктураПроверки.ВыбранноеДействие = "Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Форма.Записать(ПараметрыЗаписи) И ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
		Форма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписьВФормеДокументаУвольнение(Форма, ПараметрыЗаписи, ЗакрытьПослеЗаписи) Экспорт
	
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	Если Форма.Записать(ПараметрыЗаписи) И ЗакрытьПослеЗаписи И Не Форма.ЖдатьЗакрытияФормыУведомления Тогда 
		Форма.Закрыть();
	ИначеЕсли ЗакрытьПослеЗаписи Тогда
		Форма.ЖдатьЗакрытияФормыУведомления = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНаСоответствиеШтатномуРасписанию(Форма, Объект, ИсправленныйДокумент = Неопределено) Экспорт 
	
	ДанныеОЗанятыхПозициях = Форма.ПолучитьДанныеОЗанятыхПозициях();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДанныеОЗанятыхПозициях", ДанныеОЗанятыхПозициях);
	ПараметрыФормы.Вставить("ПроверкаПередЗаписью", Ложь);
	ПараметрыФормы.Вставить("ПроверяемыйРегистратор", Объект.Ссылка);
	
	Если ИсправленныйДокумент <> Неопределено Тогда
		ПараметрыФормы.Вставить("ИсправленныйДокумент", ИсправленныйДокумент);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьНаСоответствиеШтатномуРасписаниюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ПроверкаСоответствияШтатномуРасписанию", ПараметрыФормы, Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПроверитьНаСоответствиеШтатномуРасписаниюЗавершение(СтруктураПроверки, ДополнительныеПараметры) Экспорт 
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если СтруктураПроверки <> Неопределено И СтруктураПроверки.ВыбранноеДействие = "ОК" Тогда
		УправлениеШтатнымРасписаниемКлиент.ОбработатьРезультатыПроверки(Форма, СтруктураПроверки.АдресРезультатаПроверки);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоличествоСтавокРегулирование(Форма, КоличествоСтавок, Направление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Форма.Модифицированность = Истина;
	
	Если ПолучитьФункциональнуюОпциюИнтерфейса("ИспользоватьРаботуНаНеполнуюСтавку") Тогда
		КоличествоСтавок = КоличествоСтавок + Направление * 0.5;
	Иначе
		КоличествоСтавок = Окр(КоличествоСтавок + Направление, 0, ?(Направление > 0, РежимОкругления.Окр15как10, РежимОкругления.Окр15как20));
	КонецЕсли; 
	
КонецПроцедуры	

Процедура ДобавитьПараметрыОтбораПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(Форма, ПараметрыОткрытия) Экспорт
	
	Если Форма.ПолучитьФункциональнуюОпциюФормы("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		
		Если ПараметрыОткрытия = Неопределено Тогда
			ПараметрыОткрытия = Новый Структура;
		КонецЕсли; 
		
		ПараметрыОткрытия.Вставить("УчитыватьОтборПоПодразделению", Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы И ПараметрыРаботыКлиента.ВосстановитьПрисоединенныеФайлы Тогда
		ОткрытьФорму("Обработка.ИсправлениеПроблемыСПрисоединеннымиФайлами.Форма.Форма");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
